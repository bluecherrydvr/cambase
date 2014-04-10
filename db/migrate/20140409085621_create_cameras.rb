class CreateCameras < ActiveRecord::Migration
  def change
    create_table :cameras do |t|
      t.string :model
      t.belongs_to :manufacturer, index: true

      t.timestamps
    end
  end
end
