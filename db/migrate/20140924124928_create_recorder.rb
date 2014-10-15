class CreateRecorder < ActiveRecord::Migration
  def change
    create_table :recorders do |t|
      t.belongs_to :vendor, index: true
      t.string  :recorder_slug, index: true
      t.string :name, uniq: true, index: true
      t.string :model
      t.string :official_url
      t.text :jpeg_url
      t.text :h264_url
      t.text :mjpeg_url
      t.string :resolution
      t.string :default_username
      t.string :default_password
      t.string :type
      t.integer :input_channels
      t.integer :playback_channels
      t.boolean :audio_in
      t.boolean :audio_out
      t.boolean :onvif
      t.boolean :psia
      t.boolean :ptz
      t.boolean :upnp
      t.boolean :discontinued
      t.boolean :support_3rdparty
      t.timestamps
    end
  end
end
