json.message "All reviews"
json.review_average_rating @review_average_rating
json.reviews @reviews.each do |review|
  json.reviews review
  json.review_by_name review.review_by.full_name
  json.profile_image review.review_by.profile_image.attached? ? review.review_by.profile_image.blob.url : ''
  json.review_images review.images.each do |image|
    json.image image.blob.url
  end
end