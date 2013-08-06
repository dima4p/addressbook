source 'https://rubygems.org'

gem 'rails', '3.2.14'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'sqlite3'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem 'therubyracer', :platforms => :ruby
  gem "compass-rails"
  gem "fancy-buttons"

  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'

# models
gem 'rails3_acts_as_paranoid'

# auth
gem 'authlogic'
gem 'cancan'
gem 'omniauth-facebook'

# views
gem "haml-rails"
gem "simple_form"

group :development do
  gem 'translations_sync'
end

group :test, :development do
  gem "rspec-rails"
  gem 'guard'
  gem 'guard-rspec'
end

group :test do
  gem "capybara"
  gem "capybara-webkit"
  gem 'database_cleaner'
  gem "factory_girl_rails"
  gem "shoulda"
  gem 'rb-inotify'
  gem 'email_spec'
end

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'debugger'
