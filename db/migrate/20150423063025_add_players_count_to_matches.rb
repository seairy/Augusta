class AddPlayersCountToMatches < ActiveRecord::Migration
  def change
    add_column :matches, :players_count, :integer, default: 0, null: false, after: :started_at
  end
end
