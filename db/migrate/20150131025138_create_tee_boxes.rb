# -*- encoding : utf-8 -*-
class CreateTeeBoxes < ActiveRecord::Migration
  def change
    create_table :tee_boxes do |t|
      t.references :hole, null: false
      t.string :color_cd, limit: 20, null: false
      t.integer :distance_from_hole, limit: 3, null: false
      t.timestamps null: false
    end
  end
end
