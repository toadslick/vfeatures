FactoryBot.define do

  factory :change do
		action { 'update' }
		association :target, factory: :feature
		diff { {} }
  end
end
