require 'sidekiq'
require 'sidekiq/web'
require 'rack/ssl-enforcer'

use Rack::Auth::Basic do |username, password|
  username == ENV['SIDEKIQ_USERNAME'] && password == ENV['SIDEKIQ_PASSWORD']
end

Sidekiq.configure_client do |config|
  config.redis = { size: 1, url: ENV['SIDEKIQ_REDIS_URL'], namespace: ENV['SIDEKIQ_REDIS_NAMESPACE'] }
end

use Rack::SslEnforcer if ENV['RACK_ENV'] == 'production'

use Rack::Session::Cookie, secret: File.read('.session.key'), same_site: true, max_age: 86_400

run Sidekiq::Web
