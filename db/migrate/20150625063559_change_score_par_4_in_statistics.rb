class ChangeScorePar4InStatistics < ActiveRecord::Migration
  def change
    change_column :statistics, :score_par_4, :float
  end
end
