class AddAdditionalInformationToCameras < ActiveRecord::Migration
  def change
    add_column :cameras, :additional_information, :hstore
  end
end
