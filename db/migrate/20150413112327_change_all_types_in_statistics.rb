class ChangeAllTypesInStatistics < ActiveRecord::Migration
  def change
    change_column :statistics, :score, :integer, limit: 2
    change_column :statistics, :net, :integer, limit: 2
    change_column :statistics, :putts, :integer, limit: 2
    change_column :statistics, :penalties, :integer, limit: 2
    change_column :statistics, :score_par_3, :integer, limit: 2
    change_column :statistics, :score_par_4, :integer, limit: 2
    change_column :statistics, :score_par_5, :integer, limit: 2
    change_column :statistics, :double_eagle, :integer, limit: 2
    change_column :statistics, :eagle, :integer, limit: 2
    change_column :statistics, :birdie, :integer, limit: 2
    change_column :statistics, :par, :integer, limit: 2
    change_column :statistics, :bogey, :integer, limit: 2
    change_column :statistics, :double_bogey, :integer, limit: 2
  end
end
