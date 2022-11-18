json.data user
json.profile_image user.profile_image.attached? ? user.profile_image.blob.url : ''
json.selfie user.selfie.attached? ? user.selfie.blob.url : ''
json.id_front_image user.id_front_image.attached? ? user.id_front_image.blob.url : ''
json.id_back_image user.id_back_image.attached? ? user.id_back_image.blob.url : ''
json.portfolio(user.portfolio) do |portfolio|
  json.portfolio_url portfolio.present? ? portfolio.blob.url : ''
end
json.camera_detail user.camera_detail
if user.profile_type == 'bestie'
  json.other_input_equipment user.camera_detail.others do |other|
    json.other other
  end
end
json.interest user.interests
json.talent user.talents
json.social_media user.social_media
