# -*- encoding : utf-8 -*-
class CreateHoles < ActiveRecord::Migration
  def change
    create_table :holes do |t|
      t.string :uuid, limit: 36, null: false
      t.references :group, null: false
      t.string :name, limit: 50, null: false
      t.integer :par, limit: 1, null: false
      t.timestamps null: false
    end
  end
end
