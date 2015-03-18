class RenameMatchIdToPlayerIdInScorecards < ActiveRecord::Migration
  def change
    rename_column :scorecards, :match_id, :player_id
  end
end
