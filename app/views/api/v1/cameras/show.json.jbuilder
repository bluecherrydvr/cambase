json.cameras do
  json.partial! 'api/v1/cameras/camera', camera: @camera
end
