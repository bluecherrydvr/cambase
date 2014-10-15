class AddDefaultUsernameAndPasswordToCameras < ActiveRecord::Migration
  def change
    add_column :cameras, :default_username, :string
    add_column :cameras, :default_password, :string
    remove_column :cameras, :credentials
  end
end
