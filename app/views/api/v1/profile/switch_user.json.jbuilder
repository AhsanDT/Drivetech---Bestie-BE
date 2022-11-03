json.data @current_user
json.profile_image @current_user.profile_image.attached? ? @current_user.profile_image.blob.url : ''
json.selfie @current_user.selfie.attached? ? @current_user.selfie.blob.url : ''
json.id_front_image @current_user.id_front_image.attached? ? @current_user.id_front_image.blob.url : ''
json.id_back_image @current_user.id_back_image.attached? ? @current_user.id_back_image.blob.url : ''
json.portfolio(@current_user.portfolio) do |portfolio|
  json.portfolio_url portfolio.present? ? portfolio.blob.url : ''
end
json.camera_detail @current_user.camera_detail
json.interest @current_user.interests
json.talent @current_user.talents
json.social_media @current_user.social_media
