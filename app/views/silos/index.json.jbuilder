json.array! @silos do |silo|
  json.(silo, :id, :key, :release_id)
end
