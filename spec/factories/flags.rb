FactoryBot.define do

  factory :flag do
    feature
    release

    factory :enabled_flag do
      enabled { true }
    end
  end

end
