RSpec::Matchers.define :have_validation_error do |attr_key, err_key|

  match do |record|
    record.errors.details[attr_key].map do |hash|
      hash[:error]
    end.include?(err_key)
  end

  failure_message do |record|
    if record.valid?
      "expected #{record} to be invalid"
    else
      "expected attribute '#{attr_key}' to have a validation error of '#{err_key}'\n\n#{record.errors.details}"
    end
  end

end
