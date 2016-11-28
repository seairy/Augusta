class RenameStrokesToScoreInScorecards < ActiveRecord::Migration
  def change
    rename_column :scorecards, :strokes, :score
  end
end
