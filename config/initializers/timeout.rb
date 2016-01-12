# config/initializers/timeout.rb
# seconds
if Rails.env.production?
  require 'rack-timeout'
  Rack::Timeout.timeout = 20 
end