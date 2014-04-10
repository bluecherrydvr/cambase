json.array!(@cameras) do |camera|
  json.extract! camera, :id, :model, :manufacturer_id
  json.url camera_url(camera, format: :json)
end
