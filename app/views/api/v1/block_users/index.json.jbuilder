json.blocked_users @blocked_users.each do |user|
  json.id user.id
  json.blocked_user_id user.blocked_user_id
  json.blocked_by_id user.blocked_by_id
  json.blocked_user_name user.blocked_user.full_name
  json.blocked_user_image user.blocked_user.profile_image.attached? ? user.blocked_user.profile_image.blob.url : ''
  json.created_at user.created_at
  json.updated_at user.updated_at
end