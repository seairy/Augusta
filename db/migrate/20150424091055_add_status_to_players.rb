class AddStatusToPlayers < ActiveRecord::Migration
  def change
    add_column :players, :status, :string, limit: 10, after: :score
  end
end
