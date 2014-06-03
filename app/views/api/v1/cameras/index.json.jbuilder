json.prettify!
json.partial! 'api/v1/metadata'
json.data do |data|
  json.partial! 'api/v1/paging', object: @cameras, path: api_v1_cameras_url
  json.cameras @cameras do |camera|
    json.partial! 'api/v1/cameras/camera', camera: camera
  end
end
