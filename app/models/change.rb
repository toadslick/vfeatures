class Change < ApplicationRecord

  ACTIONS = %w( create update destroy )

  belongs_to :target,
    polymorphic: true

  validates :action,
    inclusion: {
      in: ACTIONS
    }

  validates :target,
    presence: true

  validates :target_key,
    presence: true

end
