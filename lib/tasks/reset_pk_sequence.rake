desc "Fix Postgres duplicate key violation"

task :reset_pk_sequence => :environment do
  ActiveRecord::Base.connection.tables.each { |t| ActiveRecord::Base.connection.reset_pk_sequence!(t) }
end
