json.(@flag, :id, :enabled)

json.release @flag.release, :id, :key

json.feature @flag.feature, :id, :key
