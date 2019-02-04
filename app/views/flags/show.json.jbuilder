json.(@flag, :id, :created_at, :updated_at)

json.release @flag.release, :id, :key, :created_at, :updated_at

json.feature @flag.feature, :id, :key, :created_at, :updated_at
