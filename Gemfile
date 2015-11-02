# -*- mode: ruby -*-
source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.1.4'
# Use postgres as the database for Active Record
gem 'pg', '~> 0.17'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.3'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer',  platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
gem 'jquery-turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0',          group: :doc

# Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
gem 'spring',        group: :development

# Bootstrap for easy css
gem 'bootstrap-sass', '~> 3.2.0'
gem 'autoprefixer-rails', '~> 2.2.0'

# Simple form generation - this is the one that provides better compatbility with bootstrap 3.2
gem 'simple_form', '3.1.0.rc2'

# Scheduling solution
gem 'rufus-scheduler', '~> 3.0'

# Dynamic table displays
gem 'jquery-datatables-rails', '~> 2.2'
#gem 'ajax-datatables-rails', '~> 0.2'
gem 'ajax-datatables-rails', git: 'git://github.com/antillas21/ajax-datatables-rails.git', branch: 'master'
gem 'kaminari', '~> 0.16.1'

# Date-time picker
gem 'momentjs-rails', '>= 2.8.1'
gem 'bootstrap3-datetimepicker-rails', '~> 3.1'

# Dynamic nested forms
gem 'cocoon', '~> 1.2'

# JSON serialization
gem 'active_model_serializers', '~> 0.9'

# Configuration control
gem 'rails_config', '~> 0.4'

# Envcrypt for password decryption
gem 'envcrypt', '~> 0.1'

# Execute SOAP commands
gem 'savon', '~> 2.5'
gem 'httpclient', '~> 2.3'

# Logging utility
gem 'logging', '~> 1.8'

# AWS Utilities
gem 'aws-sdk-v1', '~> 1'

# Save blanks as nil
gem 'nilify_blanks', '~> 1.1'

# REST client
gem 'rest_client', '~> 1.8'

# Zip file support
gem 'rubyzip', '~> 1.1'

group :development do
  gem 'rails-erd'
end

group :development, :test do
  gem 'rspec-rails', '~> 3.0'
  gem 'factory_girl_rails', '~> 4.4'
  gem 'shoulda-matchers', '~> 2.6'
  gem 'database_cleaner', '~> 1.3'
  gem 'byebug'
end

group :test do
  gem 'selenium-webdriver', '~> 2.13'
  gem 'capybara', '~> 2.4'
  gem 'capybara-webkit', '~> 1.3'
  gem 'faker', '~> 1.4'
  gem 'launchy', '~> 2.4'
  gem 'guard-rspec', '~> 4.3'

  # Mock web reponses
  gem 'webmock', '~> 1.18'
end

group :production do
  gem 'rails_12factor', '0.0.2'
end

# Use ActiveModel has_secure_password
 gem 'bcrypt', '~> 3.1.7'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]

