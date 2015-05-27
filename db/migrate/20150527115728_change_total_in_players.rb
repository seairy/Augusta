class ChangeTotalInPlayers < ActiveRecord::Migration
  def change
    change_column :players, :total, :integer, limit: 2
  end
end
