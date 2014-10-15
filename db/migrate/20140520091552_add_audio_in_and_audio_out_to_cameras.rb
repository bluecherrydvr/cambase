class AddAudioInAndAudioOutToCameras < ActiveRecord::Migration
  def change
    add_column :cameras, :audio_in, :boolean
    add_column :cameras, :audio_out, :boolean
  end
end
