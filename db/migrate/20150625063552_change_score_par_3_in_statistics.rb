class ChangeScorePar3InStatistics < ActiveRecord::Migration
  def change
    change_column :statistics, :score_par_3, :float
  end
end
