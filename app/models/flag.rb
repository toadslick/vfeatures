class Flag < ApplicationRecord

  belongs_to :feature
  belongs_to :release

end
