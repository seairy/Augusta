class AddUuidToPlayers < ActiveRecord::Migration
  def change
    add_column :players, :uuid, :string, limit: 36, null: false, after: :id
  end
end
