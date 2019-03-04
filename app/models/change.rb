class Change < ApplicationRecord

  ACTIONS = %w( create update destroy )

  belongs_to :target,
    polymorphic: true

  belongs_to :user

  validates :target_action,
    inclusion: {
      in: ACTIONS
    }

  validates :target,
    presence: true

  validates :target_key,
    presence: true

  validates :user,
    presence: true

end
