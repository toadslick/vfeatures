FactoryBot.define do

  factory :silo do
    release
    sequence(:key) { |n| "silo#{n}" }
  end

end
