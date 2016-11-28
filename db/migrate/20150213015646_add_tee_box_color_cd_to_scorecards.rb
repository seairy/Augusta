class AddTeeBoxColorCdToScorecards < ActiveRecord::Migration
  def change
    add_column :scorecards, :tee_box_color_cd, :string, limit: 20, null: false, after: :par
  end
end
