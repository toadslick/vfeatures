json.array! @silos do |silo|
  json.(silo, :id, :key, :release_id, :created_at, :updated_at)
end
