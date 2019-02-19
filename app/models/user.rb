class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  devise :database_authenticatable,
    :jwt_authenticatable,
    jwt_revocation_strategy: self

  has_many :logged_changes,
    class_name: 'Change',
    as: :user

  def encrypted_password
    ''
  end
end
