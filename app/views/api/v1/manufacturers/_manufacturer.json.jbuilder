manufacturer ||= @manufacturer

json.name manufacturer['name']
json.info manufacturer['info']
json.mac manufacturer['mac']
json.text manufacturer['text']
json.cameras manufacturer['cameras']
json.url api_v1_manufacturer_url(manufacturer, format: :json)

if manufacturer.class == ActiveRecord::Base && !manufacturer.persisted? &&
  !manufacturer.valid?
  json.errors manufacturer.errors.messages
end
