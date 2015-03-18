class RenameMatchIdToPlayerIdInStatistics < ActiveRecord::Migration
  def change
    rename_column :statistics, :match_id, :player_id
  end
end
