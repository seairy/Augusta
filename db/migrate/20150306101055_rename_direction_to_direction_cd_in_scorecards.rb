class RenameDirectionToDirectionCdInScorecards < ActiveRecord::Migration
  def change
    rename_column :scorecards, :direction, :direction_cd
  end
end
