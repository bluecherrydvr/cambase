class CreateManufacturers < ActiveRecord::Migration
  def change
    create_table :manufacturers do |t|
      t.string :name, uniq: true
      t.text :info
      t.text :mac, :text, array: true, default: []
      t.timestamps
    end
  end
end
