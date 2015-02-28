class RenamePenaltyToPenaltiesInScorecards < ActiveRecord::Migration
  def change
    rename_column :scorecards, :penalty, :penalties
  end
end
