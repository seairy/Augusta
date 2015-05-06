class DropLeaderboards < ActiveRecord::Migration
  def change
    drop_table :leaderboards
  end
end
