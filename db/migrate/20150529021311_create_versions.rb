class CreateVersions < ActiveRecord::Migration
  def change
    create_table :versions do |t|
      t.integer :code, null: false
      t.integer :major, :minor, :point, limit: 2, null: false
      t.string :file, limit: 100, null: false
      t.text :description
      t.string :state, limit: 50, null: false
      t.timestamps null: false
    end
  end
end