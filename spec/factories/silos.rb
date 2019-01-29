FactoryBot.define do

  factory :silo do
    sequence(:key) { |n| "silo-#{n}" }
  end

end
