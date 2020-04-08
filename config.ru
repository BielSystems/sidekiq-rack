require 'sidekiq'

use Rack::Auth::Basic do |username, password|
  username == ENV['SIDEKIQ_USERNAME'] && password == ENV["SIDEKIQ_PASSWORD"]
end

Sidekiq.configure_client do |config|
  config.redis = { size: 1, url: ENV["SIDEKIQ_REDIS_URL"], namespace: ENV["SIDEKIQ_REDIS_NAMESPACE"] }
end

require 'sidekiq/web'
run Sidekiq::Web