json.(@silo, :id, :key, :created_at, :updated_at)

json.release @silo.release, :id, :key, :created_at, :updated_at
