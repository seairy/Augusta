class AddPositionToPlayers < ActiveRecord::Migration
  def change
    add_column :players, :position, :string, limit: 10, after: :scoring_type_cd
  end
end
