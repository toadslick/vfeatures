json.array! @features do |feature|
  json.(feature, :id, :key, :created_at, :updated_at)
end
