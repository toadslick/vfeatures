module ChangeLogger
	extend ActiveSupport::Concern

	included do
		before_action :authenticate_user!
	end

	def log_and_save(record)
		action = record.new_record? ? 'create' : 'update'
		log_transaction record, action, &:save
	end

	def log_and_destroy(record)
		log_transaction record, 'destroy', &:destroy
	end

	private

	# Perform the database operation on the given record,
	# and also create a new Change record.
	#
	# Throw a Rollback exception if the operation on the record
	# returns a falsy value. This will undo the Change record if,
	# for example, the operation fails validation.
	def log_transaction(record, action)
		change = Change.new({
			user: current_user,
			target: record,
			target_key: record.key,
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
