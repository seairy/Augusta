class ChangeScorePar5InStatistics < ActiveRecord::Migration
  def change
    change_column :statistics, :score_par_5, :float
  end
end
