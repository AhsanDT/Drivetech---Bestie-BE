json.users(@users) do |user|
  json.user user
  json.profile_image user.profile_image.attached? ? user.profile_image.blob.url : ''
end