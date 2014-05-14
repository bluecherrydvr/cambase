ruby '2.0.0'
source 'http://rubygems.org'
source 'https://rails-assets.org'

gem 'rails', '4.1.0'
gem 'pg'
gem "paperclip"

gem 'sass-rails', '~> 4.0.3'
gem 'compass-rails'
gem 'bootstrap-sass'
gem "autoprefixer-rails"
gem 'rails-assets-packery'

gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'sprockets-rails', github: 'rails/sprockets-rails', branch: '2-1-stable'
gem 'jquery-rails'
# gem 'turbolinks'
gem 'jquery-turbolinks'

gem 'jbuilder', '~> 2.0'
gem 'sdoc', '~> 0.4.0',          group: :doc

gem 'spring',        group: :development

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use debugger
# gem 'debugger', group: [:development, :test]

gem 'rails_admin', :git => 'https://github.com/sferik/rails_admin.git'
gem 'devise'

gem 'swagger-docs'
gem 'swagger-ui_rails'

gem 'kaminari'

gem 'ransack'

gem 'aws-sdk'

gem 'stringex'

gem 'paper_trail', '~> 3.0.1'

group :production do
  gem 'rails_12factor'
# gem 'unicorn'
end

group :development do
  gem "awesome_print"
# gem 'capistrano-rails'
end

group :development, :test do
  gem 'guard'
  gem 'guard-livereload', :require => false
  gem 'rspec-rails'
  gem 'capybara', :git => 'git://github.com/jnicklas/capybara.git'
  gem 'launchy'
  gem 'database_cleaner'
  gem 'rb-inotify', :require => false
  gem 'rb-fsevent', :require => false
  gem 'rb-fchange', :require => false
end
