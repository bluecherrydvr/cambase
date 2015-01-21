model ||= @model

if model
	json.id model['model_slug']
	json.vendor_id model.vendor['vendor_slug']
	json.model model['model']
	json.jpeg_url model['jpeg_url']
	json.h264_url model['h264_url']
	json.mjpeg_url model['mjpeg_url']
	json.manual_url model['manual_url']
	json.resolution model['resolution']
	json.firmware model['firmware']
	json.fov model['fov']
	json.shape model['shape']
	json.onvif model['onvif']
	json.psia model['psia']
	json.ptz model['ptz']
	json.infrared model['infrared']
	json.varifocal model['varifocal']
	json.sd_card model['sd_card']
	json.upnp model['upnp']
	json.poe model['poe']
	json.wifi model['wifi']
	json.discontinued model['discontinued']
	json.audio_in model['audio_in']
	json.audio_out model['audio_out']
	json.default_username model['default_username']
	json.default_password model['default_password']
	json.official_url model['official_url']
	json.additional_information model['additional_information']
	json.images do
	  json.array! model.images.sorted, partial: 'api/v1/image', as: :image
	end
	json.url api_v1_model_url(model.model_slug, format: :json)
	if model.class == ActiveRecord::Base && !model.persisted? &&
	  !model.valid?
	  json.errors model.errors.messages
	end
else
	raise ActiveRecord::RecordNotFound
end
