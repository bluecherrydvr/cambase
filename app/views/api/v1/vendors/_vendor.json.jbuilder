vendor ||= @vendor

if vendor
	json.id vendor['vendor_slug']
	json.name vendor['name']
	json.logo vendor.image ? vendor.image.file.url : ''
	json.mac vendor['mac']

	if vendor.class == ActiveRecord::Base && !vendor.persisted? &&
	  !vendor.valid?
	  json.errors vendor.errors.messages
	end
else
	raise ActiveRecord::RecordNotFound
end