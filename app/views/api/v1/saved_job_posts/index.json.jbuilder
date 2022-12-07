json.data @saved_job_posts
json.posts @saved_job_posts.each do |saved_job|
  json.post saved_job.post
  json.profile_image saved_job.post.user.profile_image.attached? ? saved_job.post.user.profile_image.blob.url : ''
end