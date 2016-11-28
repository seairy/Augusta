class ChangePenaltiesInStrokes < ActiveRecord::Migration
  def change
    change_column :strokes, :penalties, :integer, limit: 1
  end
end
