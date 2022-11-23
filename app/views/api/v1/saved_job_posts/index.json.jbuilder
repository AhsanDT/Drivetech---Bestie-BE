json.data @saved_job_posts
json.posts @saved_job_posts.each do |saved_job|
  json.post saved_job.post
end