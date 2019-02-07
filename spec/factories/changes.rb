FactoryBot.define do

  factory :change do
		action { 'update' }
		association :target, factory: :feature
		diff { {} }
    target_key { target.key }
  end
end
