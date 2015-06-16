class AddCaddieIdToPlayers < ActiveRecord::Migration
  def change
    add_column :players, :caddie_id, :integer, after: :match_id
  end
end
