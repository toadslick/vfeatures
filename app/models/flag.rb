class Flag < ApplicationRecord

  belongs_to :feature
  belongs_to :release

  has_many :logged_changes,
    class_name: 'Change',
    as: :target

end
