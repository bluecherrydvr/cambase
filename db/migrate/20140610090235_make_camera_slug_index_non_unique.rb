class MakeCameraSlugIndexNonUnique < ActiveRecord::Migration
  def change
    remove_index :cameras, :camera_slug
    add_index :cameras, :camera_slug
  end
end
