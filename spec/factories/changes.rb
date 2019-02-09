FactoryBot.define do

  factory :change do
    user
		action { 'update' }
		association :target, factory: :feature
		diff { {} }
    target_key { target.key }
  end
end
