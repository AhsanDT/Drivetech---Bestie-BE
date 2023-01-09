require "sidekiq/api"
# Redis.exists_returns_integer = false

redis_config = { url: ENV['REDIS_ACTION_CABLE'] }

Sidekiq.configure_server do |config|
  config.redis = redis_config
end

Sidekiq.configure_client do |config|
  config.redis = redis_config
end