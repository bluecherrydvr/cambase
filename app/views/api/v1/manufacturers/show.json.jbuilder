json.prettify!
json.partial! 'api/v1/metadata'
json.data do |data|
  json.partial! 'api/v1/paging', object: @cameras, path: api_v1_manufacturer_url
  json.partial! 'api/v1/manufacturers/manufacturer', manufacturer: @manufacturer
  json.cameras @manufacturer.cameras do |camera|
    json.partial! 'api/v1/cameras/camera', camera: camera
  end
end
