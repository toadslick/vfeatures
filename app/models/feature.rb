class Feature < ApplicationRecord

  has_many :flags
  accepts_nested_attributes_for :flags,
    update_only: true,
    reject_if: :new_record?

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

  def self.build_with_flags(params)
    feature = Feature.new(params)
    Release.all.each do |release|
      feature.flags.build({ release: release })
    end
    feature
  end
end
