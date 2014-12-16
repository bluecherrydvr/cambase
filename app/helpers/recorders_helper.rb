module RecordersHelper
	def vendor_exists(vendor)
		return vendor ? vendor.id : ""
	end
end