class RenamePuttingToPuttsInScorecards < ActiveRecord::Migration
  def change
    rename_column :scorecards, :putting, :putts
  end
end
