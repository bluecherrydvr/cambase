class ChangeAddInfoFormatInModel < ActiveRecord::Migration
  def up
    change_column :models, :additional_information, :string
  end

  def down
    change_column :models, :additional_information, :hstore
  end
end
