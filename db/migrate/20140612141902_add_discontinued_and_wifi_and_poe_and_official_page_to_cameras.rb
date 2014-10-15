class AddDiscontinuedAndWifiAndPoeAndOfficialPageToCameras < ActiveRecord::Migration
  def change
    add_column :cameras, :discontinued, :boolean
    add_column :cameras, :wifi, :boolean
    add_column :cameras, :poe, :boolean
    add_column :cameras, :official_url, :string
  end
end
