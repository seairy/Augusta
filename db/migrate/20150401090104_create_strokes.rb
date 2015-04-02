class CreateStrokes < ActiveRecord::Migration
  def change
    create_table :strokes do |t|
      t.string :uuid, limit: 36, null: false
      t.references :scorecard, null: false
      t.integer :sequence, limit: 2, null: false
      t.integer :distance_from_hole, limit: 3, null: false
      t.string :point_of_fall_cd, limit: 20
      t.string :penalties, limit: 10
      t.string :club_cd, limit: 10, null: false
      t.timestamps null: false
    end
  end
end
