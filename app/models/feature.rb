class Feature < ApplicationRecord

  has_many :flags,
    dependent: :destroy

  has_many :logged_changes,
    class_name: 'Change',
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

  # Build a new Feature and an associated Flag for each existing Release.
  # When the record is saved, both the Feature and all of its Flags
  # will be created at the same time. Flags are disabled by default.
  def self.build_with_flags(params)
    feature = Feature.new(params)
    Release.all.each do |release|
      feature.flags.build({ release: release })
    end
    feature
  end
end
