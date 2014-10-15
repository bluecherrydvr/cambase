class RenameRecoderType < ActiveRecord::Migration
  def self.up
  	rename_column :recorders, :type, :recorder_type
  end
end
