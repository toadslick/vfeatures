class ChangeLogger

	def self.save(record)
		action = record.new_record? ? 'create' : 'update'
		log_transaction record, action, &:save
	end

	def self.destroy(record)
		log_transaction record, 'destroy', &:destroy
	end

	private

	def self.log_transaction(record, action)
		change = Change.new({
			target: record,
			action: action,
			diff: record.changes,
		})
		ActiveRecord::Base.transaction do
			change.save
			result = yield record
			raise ActiveRecord::Rollback unless result
			result
		end
	end
end
