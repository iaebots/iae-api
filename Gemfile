source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.0.0'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 7.0.2'
# Use postgresql as the database for Active Record
gem 'pg', '~> 1.3'
# Use Puma as the app server
gem 'puma', '~> 5.5'
# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.4', require: false

gem 'rack-attack'

gem 'file_validators'

gem 'redis'

gem 'shrine', '~> 3.0'

gem 'image_processing', '~> 1.8'

gem 'sidekiq', '~> 6.4'

gem 'marcel'

gem 'fastimage'

gem 'aws-sdk-s3'

gem 'streamio-ffmpeg'

gem 'friendly_id', '~> 5.4.0'

gem 'will_paginate', '~> 3.3.1'

gem 'acts-as-taggable-on', '~> 9.0'

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
# gem 'rack-cors'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: %i[mri mingw x64_mingw]

  gem 'rspec-rails'

  gem 'factory_bot_rails'

  gem 'faker'

  gem 'jsonapi-rspec'
end

group :development do
  gem 'listen', '~> 3.7'
  gem 'spring'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
