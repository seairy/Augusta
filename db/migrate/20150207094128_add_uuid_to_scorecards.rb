class AddUuidToScorecards < ActiveRecord::Migration
  def change
    add_column :scorecards, :uuid, :string, limit: 36, null: false, after: :id
  end
end
