# config/initializers/timeout.rb
# seconds
require 'rack-timeout'
Rack::Timeout.timeout = 20 if Rails.env.production?