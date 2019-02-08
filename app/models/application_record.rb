class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  strip_attributes

  scope :latest, -> do
    order(created_at: :desc)
  end

  scope :alphabetically, -> do
    order(key: :asc)
  end

  scope :page, -> (page_index, records_per_page) do
    limit(records_per_page).offset(page_index * records_per_page)
  end

  def self.latest_record
    latest.limit(1).first
  end
end
