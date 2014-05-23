# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

seed_file = File.join(Rails.root, 'db', 'seeds', 'cameras.yml')
documents = YAML.load_stream(open(seed_file))

documents.each do |doc|
  doc.each do |camera|
    camera.delete 'id'
    camera['manufacturer'].delete 'id'
    manufacturer = Manufacturer.where(camera['manufacturer']).first_or_create
    camera['manufacturer'] = manufacturer
    Camera.create(camera)
  end
end
