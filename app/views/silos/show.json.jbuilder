json.(@silo, :id, :key)

if @silo.release
  json.release @silo.release, :id, :key
end
