class CreateProvinces < ActiveRecord::Migration
  def change
    create_table :provinces do |t|
      t.string :uuid, limit: 36, null: false
      t.string :name, limit: 50, null: false
      t.integer :cities_count, default: 0, null: false
      t.timestamps null: false
    end
    add_index :provinces, :uuid, unique: true
    add_index :provinces, :name
  end
end
