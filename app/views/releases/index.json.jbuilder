json.array! @releases do |release|
  json.(release, :id, :key, :created_at, :updated_at)
end
