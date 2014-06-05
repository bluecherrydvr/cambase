manufacturer ||= @manufacturer

json.id manufacturer['manufacturer_slug']
json.name manufacturer['name']
json.logo manufacturer.image ? manufacturer.image.file.url : ''
json.mac manufacturer['mac']

if manufacturer.class == ActiveRecord::Base && !manufacturer.persisted? &&
  !manufacturer.valid?
  json.errors manufacturer.errors.messages
end
