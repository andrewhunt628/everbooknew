source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.4'
# Use sqlite3 as the database for Active Record

# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

gem 'rack-cors', :require => 'rack/cors', group: :development

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc
gem 'haml'
gem 'bootstrap-sass', '~> 3.3.5'
gem 'simple_form'
gem 'devise'
gem 'devise_invitable'
gem "omniauth-google-oauth2"
gem 'omniauth-facebook'
gem "koala" # Facebook Api
gem "paperclip", "~> 4.3"
gem 'aws-sdk', '< 2.0'
gem 'masonry-rails'
gem "font-awesome-rails"
gem 'acts-as-taggable-on', '~> 3.4'
gem "jquery-validation-rails"

gem 'momentjs-rails'



#amistad for friendship model
gem 'amistad'
#this is for google,facebook authorization
gem "figaro"


# Use spine-js as the JavaScript library
gem "json2-rails"
gem 'eco'
gem 'underscore-rails'

#For js-upload images
gem "jquery-fileupload-rails"

gem "nested_form"

#for facebook invitations
gem "fb_graph2"


# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

gem 'forgery' #when stop use fake data move this gem into :development, :test section

group :production do
  gem "rails_12factor"
end

gem 'letter_opener' #move to :development, :test section before first relase

# use 'postgresql' in any environment
gem 'pg'
group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'sqlite3'

  gem 'byebug'
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  # automate rspec testing
  gem 'guard'
  gem 'guard-rspec', require: false
  #Generate humanize random data
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end

gem 'httparty' # for http request
