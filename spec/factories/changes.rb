FactoryBot.define do

  factory :change do
    user
		target_action { 'update' }
		association :target, factory: :feature
		diff { {} }
    target_key { target.key }
  end
end
