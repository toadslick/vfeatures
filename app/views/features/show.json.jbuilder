json.(@feature, :id, :key)

json.flags @feature.flags do |flag|
  json.(flag, :id, :enabled, :release_id)
end
