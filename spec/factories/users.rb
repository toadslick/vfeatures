FactoryBot.define do
  factory :user do
    sequence(:username) { |n| "user#{n}" }
    sequence(:jti) { |n| "jti#{n}" }
  end
end
