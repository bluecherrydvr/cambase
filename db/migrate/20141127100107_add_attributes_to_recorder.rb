class AddAttributesToRecorder < ActiveRecord::Migration
  def change
	add_column :recorders, :usb, :integer
  	add_column :recorders, :sdhc, :integer
  	add_column :recorders, :hot_swap, :boolean
    add_column :recorders, :hdmi, :boolean
    add_column :recorders, :digital_io, :boolean
    add_column :recorders, :mobile_access, :string
    add_column :recorders, :alarms, :string
    add_column :recorders, :raid_support, :string
    add_column :recorders, :storage, :string
    add_column :recorders, :additional_information, :string
  end
end
