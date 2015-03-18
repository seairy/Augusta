class AddScoringTypeCdToPlayers < ActiveRecord::Migration
  def change
    add_column :players, :scoring_type_cd, :string, limit: 20, null: false, after: :match_id
  end
end
