desc "Create slugs for Cameras and Manufacturers"

task :make_slug => :environment do
  Camera.all.find_each(&:save)
  Manufacturer.all.find_each(&:save)
end
