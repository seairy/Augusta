class RenameStatusToTotalInPlayers < ActiveRecord::Migration
  def change
    rename_column :players, :status, :total
  end
end
