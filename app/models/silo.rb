class Silo < ApplicationRecord

  belongs_to :release

  has_many :logged_changes,
    class_name: 'Changes',
    as: :target

  validates :key,
    format: {
      with: /\A[a-z0-9]+\z/i,
      allow_blank: true,
    },
    presence: true,
    uniqueness: {
      case_sensitive: false,
    }

  validates :release,
    presence: true

end
