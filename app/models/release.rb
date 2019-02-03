class Release < ApplicationRecord

  has_many :silos
  has_many :flags

  validates :key, {
    format: {
      with: /\A[a-z0-9_\.-]+\z/i,
      allow_blank: true,
    },
    presence: true,
    uniqueness: {
      case_sensitive: false,
    },
  }
  
end
