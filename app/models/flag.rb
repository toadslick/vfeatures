class Flag < ApplicationRecord

  belongs_to :feature
  belongs_to :release

  has_many :logged_changes,
    class_name: 'Change',
    as: :target

  def key
    "#{release.key}/#{feature.key}"
  end
end
