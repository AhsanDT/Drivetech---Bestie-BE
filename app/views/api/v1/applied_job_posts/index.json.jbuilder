json.data @applied_job_posts
json.posts @applied_job_posts.each do |applied_job|
  json.applied_job applied_job
  json.post applied_job.post
  json.profile_image applied_job.post.user.profile_image.attached? ? applied_job.post.user.profile_image.blob.url : ''
end