class CreateCities < ActiveRecord::Migration
  def change
    create_table :cities do |t|
      t.string :uuid, limit: 36, null: false
      t.references :province, null: false
      t.string :name, limit: 50, null: false
      t.integer :courses_count, default: 0, null: false
      t.timestamps null: false
    end
    add_index :cities, :uuid, unique: true
    add_index :cities, :province_id
    add_index :cities, :name
  end
end
