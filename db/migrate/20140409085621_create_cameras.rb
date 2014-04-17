class CreateCameras < ActiveRecord::Migration
  def change
    create_table :cameras do |t|
      t.belongs_to :manufacturer, index: true
      t.string :model, uniq: true
      t.text :manual_url
      t.text :jpeg_url
      t.text :h264_url
      t.text :mjpeg_url
      t.string :resolution
      t.string :firmware
      t.string :credentials
      t.string :shape
      t.integer :fov
      t.boolean :onvif
      t.boolean :psia
      t.boolean :ptz
      t.boolean :infrared
      t.boolean :varifocal
      t.boolean :sd_card
      t.boolean :upnp
      t.timestamps
    end
  end
end
