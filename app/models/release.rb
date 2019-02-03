class Release < ApplicationRecord

  has_many :silos
  has_many :flags, dependent: :destroy

  accepts_nested_attributes_for :flags,
    update_only: true,
    reject_if: :new_record?

  validates :key,
    format: {
      with: /\A[a-z0-9_\.-]+\z/i,
      allow_blank: true,
    },
    presence: true,
    uniqueness: {
      case_sensitive: false,
    }

  # Build a new Release and an associated Flag for each existing Feature.
  # When the record is saved, both the Release and all of its Flags
  # will be created at the same time. Flags are disabled by default.
  def self.build_with_flags(params)
    release = Release.new(params)
    Feature.all.each do |feature|
      release.flags.build({ feature: feature })
    end
    release
  end
end
