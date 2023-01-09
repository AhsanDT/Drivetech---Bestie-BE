json.blocked_users @blocked_users.each do |user|
  json.id user.id
  json.blocked_user_id user.blocked_user_id
  json.blocked_by_id user.blocked_by_id
  json.blocked_by_name user.blocked_by.full_name
  json.blocked_by_image user.blocked_by.profile_image.attached? ? user.blocked_by.profile_image.blob.url : ''
  json.created_at user.created_at
  json.updated_at user.updated_at
end