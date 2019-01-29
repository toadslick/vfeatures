FactoryBot.define do

  factory :feature do
    sequence(:key) { |n| "feature#{n}" }
  end

end
