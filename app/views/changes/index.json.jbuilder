json.pagination @pagination,:total,:offset

json.changes @changes do |change|
  json.(change,
    :id,
    :target_type,
    :target_id,
    :target_action,
    :target_key,
    :user_id,
    :diff,
    :created_at)
end
