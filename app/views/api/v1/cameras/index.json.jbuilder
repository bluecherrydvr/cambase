json.prettify!
json.partial! 'api/v1/metadata'
json.data do |data|
  json.partial! 'api/v1/paging', object: @cameras, path: api_v1_cameras_url
  json.cameras @cameras do |camera|
    json.id camera['camera_slug']
    json.manufacturer_id camera.manufacturer['manufacturer_slug']
    json.url api_v1_camera_url(camera.camera_slug, format: :json)
  end
end
