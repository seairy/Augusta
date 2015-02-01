class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      t.string :uuid, limit: 36, null: false
      t.references :city, null: false
      t.string :name, limit: 191, null: false
      t.string :logo, limit: 100
      t.string :address, limit: 1000
      t.decimal :latitude, :longitude, precision: 18, scale: 15
      t.text :description
      t.boolean :trashed, default: false, null: false
      t.integer :groups_count, default: 0, null: false
      t.timestamps null: false
    end
    add_index :courses, :uuid, unique: true
    add_index :courses, :city_id
    add_index :courses, :name
    add_index :courses, [:latitude, :longitude]
    add_index :courses, :trashed
  end
end
