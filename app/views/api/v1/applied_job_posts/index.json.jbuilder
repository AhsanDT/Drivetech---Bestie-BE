json.data @applied_job_posts
json.posts @applied_job_posts.each do |applied_job|
  json.post applied_job.post
end