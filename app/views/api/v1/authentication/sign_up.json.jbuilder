json.data @user
json.profile_image @user.profile_image.attached? ? @user.profile_image.url : ''
json.selfie @user.selfie.attached? ? @user.selfie.blob.url : ''
json.id_front_image @user.id_front_image.attached? ? @user.id_front_image.blob.url : ''
json.id_back_image @user.id_back_image.attached? ? @user.id_back_image.blob.url : ''
json.portfolio(@user.portfolio) do |portfolio|
  json.portfolio_url portfolio.present? ? portfolio.blob.url : ''
end
json.camera_detail @user.camera_detail
json.interest @user.interests
json.talent @user.talents
json.social_media @user.social_media
