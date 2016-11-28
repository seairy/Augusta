class AddScoreToPlayers < ActiveRecord::Migration
  def change
    add_column :players, :score, :integer, limit: 2, after: :position
  end
end
