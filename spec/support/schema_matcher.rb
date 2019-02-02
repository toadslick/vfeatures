RSpec::Matchers.define :match_json_schema do |schema|
  match do |json|
    path = File.join(Dir.pwd, 'spec', 'schemas', "#{schema}.json")
    JSON::Validator.validate!(path, json, strict: true)
  end
end
