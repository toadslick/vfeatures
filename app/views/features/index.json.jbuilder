json.array! @features do |feature|
  json.(feature, :id, :key)
end
