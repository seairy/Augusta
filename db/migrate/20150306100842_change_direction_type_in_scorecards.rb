class ChangeDirectionTypeInScorecards < ActiveRecord::Migration
  def change
    change_column :scorecards, :direction, :string, limit: 10
  end
end
