class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.belongs_to :owner, polymorphic: true
      t.integer :position
      t.attachment :file
      t.timestamps
    end
  end
end
