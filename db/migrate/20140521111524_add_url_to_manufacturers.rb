class AddUrlToManufacturers < ActiveRecord::Migration
  def change
    add_column :manufacturers, :url, :string
  end
end
