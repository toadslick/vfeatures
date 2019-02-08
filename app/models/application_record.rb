class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  strip_attributes

  scope :latest, -> do
    order(created_at: :desc)
  end

  scope :alphabetically, -> do
    order(key: :asc)
  end

  def self.latest_record
    latest.limit(1).take
  end
end
