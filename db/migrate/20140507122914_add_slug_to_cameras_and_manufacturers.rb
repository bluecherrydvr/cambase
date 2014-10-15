class AddSlugToCamerasAndManufacturers < ActiveRecord::Migration
  def change
    add_column :cameras, :camera_slug, :string, unique: true
    add_column :manufacturers, :manufacturer_slug, :string, unique: true
    add_index :cameras, :camera_slug, unique: true
    add_index :manufacturers, :manufacturer_slug, unique: true
  end
end
