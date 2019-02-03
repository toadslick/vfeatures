json.(@feature, :id, :key, :created_at, :updated_at)

json.flags @feature.flags do |flag|
  json.(flag, :id, :enabled, :created_at, :updated_at, :release_id)
end
