module ModelsHelper
	def vendor_exists(vendor)
		return vendor ? vendor.id : ""
	end
end
