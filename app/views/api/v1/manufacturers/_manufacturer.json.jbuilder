manufacturer ||= @manufacturer

json.id manufacturer['manufacturer_slug']
json.name manufacturer['name']
json.logo manufacturer.image
json.url api_v1_manufacturer_url(manufacturer.manufacturer_slug, format: :json)
json.cameras manufacturer.cameras do |camera|
  json.partial! 'api/v1/cameras/camera', camera: camera
end

if manufacturer.class == ActiveRecord::Base && !manufacturer.persisted? &&
  !manufacturer.valid?
  json.errors manufacturer.errors.messages
end
