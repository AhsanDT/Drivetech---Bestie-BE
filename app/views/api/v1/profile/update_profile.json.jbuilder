json.data @profile
json.profile_image @profile.profile_image.attached? ? @profile.profile_image.blob.url : ''
json.selfie @profile.selfie.attached? ? @profile.selfie.blob.url : ''
json.id_front_image @profile.id_front_image.attached? ? @profile.id_front_image.blob.url : ''
json.id_back_image @profile.id_back_image.attached? ? @profile.id_back_image.blob.url : ''
json.portfolio(@profile.portfolio) do |portfolio|
  json.portfolio_url portfolio.present? ? portfolio.blob.url : ''
end
json.camera_detail @profile.camera_detail
json.interest @profile.interests
json.talent @profile.talents
json.social_media @profile.social_media
