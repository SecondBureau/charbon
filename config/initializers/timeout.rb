# config/initializers/timeout.rb
# seconds
Rack::Timeout.timeout = 20 if Rails.env.production?