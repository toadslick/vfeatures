json.array! @releases do |release|
  json.(release, :id, :key)
end
