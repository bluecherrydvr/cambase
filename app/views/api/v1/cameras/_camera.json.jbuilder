camera ||= @camera
json.id camera['camera_slug']
json.manufacturer_id camera.manufacturer['manufacturer_slug']
json.model camera['model']
json.jpeg_url camera['jpeg_url']
json.h264_url camera['h264_url']
json.mjpeg_url camera['mjpeg_url']
json.resolution camera['resolution']
json.shape camera['shape']
json.onvif camera['onvif']
json.psia camera['psia']
json.ptz camera['ptz']
json.infrared camera['infrared']
json.varifocal camera['varifocal']
json.sd_card camera['sd_card']
json.upnp camera['upnp']
json.audio_in camera['audio_in']
json.audio_out camera['audio_out']
json.default_username camera['default_username']
json.default_password camera['default_password']
json.images do
  json.array! camera.images, partial: 'api/v1/image', as: :image
end
json.url api_v1_camera_url(camera.camera_slug, format: :json)

if camera.class == ActiveRecord::Base && !camera.persisted? &&
  !camera.valid?
  json.errors camera.errors.messages
end
