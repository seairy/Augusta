class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.references :administrator, null: false
      t.string :title, limit: 191, null: false
      t.text :content
      t.boolean :read, default: false, null: false
      t.timestamps null: false
    end
    add_index :notifications, [:administrator_id, :read]
  end
end
