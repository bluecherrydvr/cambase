recorder ||= @recorder
json.id recorder['recorder_slug']
json.vendor_id recorder.vendor['vendor_slug']
json.recorder recorder['model']
json.jpeg_url recorder['jpeg_url']
json.h264_url recorder['h264_url']
json.mjpeg_url recorder['mjpeg_url']
json.resolution recorder['resolution']
json.shape recorder['shape']
json.onvif recorder['onvif']
json.psia recorder['psia']
json.ptz recorder['ptz']
json.infrared recorder['infrared']
json.varifocal recorder['varifocal']
json.sd_card recorder['sd_card']
json.upnp recorder['upnp']
json.poe recorder['poe']
json.wifi recorder['wifi']
json.discontinued recorder['discontinued']
json.audio_in recorder['audio_in']
json.audio_out recorder['audio_out']
json.default_username recorder['default_username']
json.default_password recorder['default_password']
json.official_url recorder['official_url']
json.images do
  json.array! recorder.images.sorted, partial: 'api/v1/image', as: :image
end
json.url api_v1_recorder_url(recorder.recorder_slug, format: :json)

if recorder.class == ActiveRecord::Base && !recorder.persisted? &&
  !recorder.valid?
  json.errors recorder.errors.messages
end
