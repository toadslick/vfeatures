class Flag < ApplicationRecord

  belongs_to :feature
  belongs_to :release

  has_many :logged_changes,
    class_name: 'Changes',
    as: :target

end
