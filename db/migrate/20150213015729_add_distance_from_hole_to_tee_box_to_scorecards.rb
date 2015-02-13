class AddDistanceFromHoleToTeeBoxToScorecards < ActiveRecord::Migration
  def change
    add_column :scorecards, :distance_from_hole_to_tee_box, :integer, limit: 3, null: false, after: :tee_box_color_cd
  end
end
