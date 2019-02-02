json.(@feature, :id, :key, :created_at, :updated_at)

json.flags @feature.flags do |flag|
  json.(flag, :id, :created_at, :updated_at)
  json.release flag.release, :id, :key, :created_at, :updated_at
end