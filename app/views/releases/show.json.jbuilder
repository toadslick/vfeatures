json.(@release, :id, :key, :created_at, :updated_at)

json.flags @release.flags do |flag|
  json.(flag, :id, :enabled, :feature_id)
end
