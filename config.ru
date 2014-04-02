require 'sidekiq'

use Rack::Auth::Basic do |username, password|
  username == ENV['SIDEKIQ_USERNAME'] && password == ENV["SIDEKIQ_PASSWORD"]
end

Sidekiq.configure_client do |config|
  config.redis = { :url => ENV["SIDEKIQ_REDIS_URL"] }
end

require 'sidekiq/web'
run Sidekiq::Web