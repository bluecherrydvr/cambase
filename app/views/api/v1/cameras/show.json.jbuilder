json.cameras do
  json.partial! 'api/v1/cameras/camera', camera: @camera, path: api_v1_cameras_url
end
