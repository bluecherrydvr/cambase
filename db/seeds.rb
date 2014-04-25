# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

seed_file = File.join(Rails.root, 'db', 'seeds', 'cameras.yml')
documents = YAML.load_stream(open(seed_file))
# NOTE: add temporary limit until the pagination is implemented
documents.first(500).each do |doc|
  doc.first(1).each do |camera|
    manufacturer_id = Manufacturer.where(:name => camera['manufacturer']).first_or_create.id
      camera['manufacturer_id'] = manufacturer_id
      Camera.create(camera.except('manufacturer'))
  end
end

puts
