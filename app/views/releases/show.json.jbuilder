json.(@release, :id, :key, :created_at, :updated_at)

json.flags @release.flags do |flag|
  json.(flag, :id, :enabled, :created_at, :updated_at, :feature_id)
end
