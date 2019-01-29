FactoryBot.define do

  factory :release do
    sequence(:key) { |n| "release-#{n}.0" }
  end

end
