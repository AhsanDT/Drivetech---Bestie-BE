json.message "Review has been created"
json.review @review
json.review_images @review.images.each do |image|
  json.image image.blob.url
end