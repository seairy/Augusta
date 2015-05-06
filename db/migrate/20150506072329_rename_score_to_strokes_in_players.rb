class RenameScoreToStrokesInPlayers < ActiveRecord::Migration
  def change
    rename_column :players, :score, :strokes
  end
end
