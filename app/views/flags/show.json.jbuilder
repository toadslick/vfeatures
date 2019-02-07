json.(@flag, :id, :created_at, :updated_at)

json.release @flag.release, :id, :key

json.feature @flag.feature, :id, :key
