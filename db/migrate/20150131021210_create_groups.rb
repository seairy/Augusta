# -*- encoding : utf-8 -*-
class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :uuid, limit: 36, null: false
      t.references :course, null: false
      t.string :name, limit: 191
      t.integer :holes_count, default: 0, null: false
      t.timestamps null: false
    end
    add_index :groups, :uuid, unique: true
    add_index :groups, :course_id
    add_index :groups, :name
  end
end
