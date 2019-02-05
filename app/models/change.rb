class Change < ApplicationRecord
  belongs_to :target, polymorphic: true
end
