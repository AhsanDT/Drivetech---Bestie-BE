require "sidekiq/api"
# Redis.exists_returns_integer = false

redis_config = { url: "redis://52.66.198.177:6379/1" }

Sidekiq.configure_server do |config|
  config.redis = redis_config
end

Sidekiq.configure_client do |config|
  config.redis = redis_config
end