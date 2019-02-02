class Feature < ApplicationRecord

  has_many :flags

  validates :key, {
    format: {
      with: /\A[a-z0-9]+\z/i,
      allow_blank: true,
    },
    presence: true,
    uniqueness: {
      case_sensitive: false,
    },
  }

end
