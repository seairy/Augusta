class AddDefaultValueToPenaltiesInStrokes < ActiveRecord::Migration
  def change
    change_column :strokes, :penalties, :integer, limit: 1, default: 0, null: false
  end
end
