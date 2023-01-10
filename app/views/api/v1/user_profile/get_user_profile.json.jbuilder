json.partial! "api/v1/shared/user", user: @user
json.posts @user.posts
json.reviews @user.reviews.each do |review|
  json.review review
  json.reviewed_by_name review.review_by.full_name
  json.reviewed_by_profile_image review.review_by.profile_image.attached? ? review.review_by.profile_image.blob.url : ''
end
json.reviews_average_rating @review_average_rating
json.conversation @conversation