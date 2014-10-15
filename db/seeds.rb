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
  doc.each do |model|
    model.delete 'id'
    model.delete 'credentials'
    model['vendor'].delete 'id'
    vendor = Vendor.where(model['vendor']).first_or_create
    model['vendor'] = vendor
    Model.create(model)
  end
end
