class CreateDocuments < ActiveRecord::Migration
  def change
    create_table :documents do |t|
      t.belongs_to :owner, polymorphic: true
      t.attachment :file
      t.timestamps
    end
  end
end
