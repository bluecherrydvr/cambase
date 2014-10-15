class RenameManufacturerToVendor < ActiveRecord::Migration
  def change
  	rename_table :manufacturers, :vendors
  end
end
