class RenameCameraToModel < ActiveRecord::Migration
  def change
    rename_table :cameras, :models
  end
end
