# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Rails.application.initialize!

ActiveRecord::Base.connection.execute('SET statement_timeout = 60000')