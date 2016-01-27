source 'https://rubygems.org'

ruby '2.1.2'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 4.2.4'
gem 'sprockets-rails', '~> 2.3'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# Use jquery as the JavaScript library
gem 'jquery-rails'
gem 'jquery-ui-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
gem 'jquery-turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'

gem "therubyracer"
gem "less-rails" #Sprockets (what Rails 3.1 uses for its asset pipeline) supports LESS
gem "twitter-bootstrap-rails"

# views
gem 'haml'

# Cameleon
gem "camaleon_cms", github: 'SecondBureau/camaleon-cms'
#gem "camaleon_cms"

# An opinionated micro-framework for creating REST-like APIs in Ruby. http://www.ruby-grape.org
gem 'grape'
gem 'hashie-forbidden_attributes'
gem 'grape-jbuilder'
#gem 'js_assets'

gem "faker"
gem 'slugify'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

group :development, :test do
  # Use sqlite3 as the database for Active Record
  gem 'sqlite3'
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  # Seed Rails application by convention, not configuration.
  gem 'sprig'
end

group :production do
  # Use postgresql as the database for Active Record
  gem 'pg'
  # Rack::Cache is suitable as a quick drop-in component to enable HTTP caching for Rack-based applications that produce freshness (Expires, Cache-Control) and/or validation (Last-Modified, ETag) information.
  gem 'rack-cache', :require => 'rack/cache'
  
  gem 'ngannotate-rails'
end

group :heroku do 
  # This gem replaces the need for the plugins, and ensures that Rails 4 is optimally configured for executing on Heroku.
  gem 'rails_12factor'
  # Puma Webserver
  gem 'puma'
  # https://github.com/heroku/rack-timeout
  gem "rack-timeout"
end


#################### Camaleon CMS include all gems for plugins and themes #################### 
require './lib/plugin_routes' 
instance_eval(PluginRoutes.draw_gems)