class ModifyModelsVendors < ActiveRecord::Migration
  def change
  	rename_column :vendors, :manufacturer_slug, :vendor_slug
  	rename_column :models, :camera_slug, :model_slug
  	rename_column :models, :manufacturer_id, :vendor_id
  end
end
