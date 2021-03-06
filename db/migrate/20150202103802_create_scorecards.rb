# -*- encoding : utf-8 -*-
class CreateScorecards < ActiveRecord::Migration
  def change
    create_table :scorecards do |t|
      t.references :match, null: false
      t.references :hole, null: false
      t.integer :number, limit: 1, null: false
      t.integer :par, limit: 1, null: false
      t.integer :strokes, limit: 1
      t.integer :putting, limit: 1
      t.integer :penalty, limit: 1
      t.integer :driving_distance, limit: 2
      t.integer :direction, limit: 1
      t.timestamps null: false
    end
  end
end
