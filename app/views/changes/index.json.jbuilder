json.pagination @pagination, :total, :offset

json.changes @changes do |change|
  json.(change, :id, :action, :target_type, :target_id, :target_key, :diff)
end
