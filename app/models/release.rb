class Release < ApplicationRecord

  has_many :silos
  has_many :flags

end
