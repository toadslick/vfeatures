class Change < ApplicationRecord
  belongs_to :target, polymorphic: true

  def self.latest
    order(:created_at).limit(1).first
  end
end
