json.all_posts @posts.each do |post|
  json.post post
  json.profile_image post.user.profile_image.attached? ? post.user.profile_image.blob.url : ''
end