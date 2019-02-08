json.(@release, :id, :key)

json.flags @release.flags do |flag|
  json.(flag, :id, :enabled, :feature_id)
end
