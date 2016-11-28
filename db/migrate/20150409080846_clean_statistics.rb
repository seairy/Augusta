class CleanStatistics < ActiveRecord::Migration
  def change
    remove_column :statistics, :longest_drive_length 
    remove_column :statistics, :average_drive_length
    remove_column :statistics, :drive_fairways_hit
    remove_column :statistics, :scrambles
    remove_column :statistics, :bounce
    remove_column :statistics, :advantage_transformation
    remove_column :statistics, :greens_in_regulation
    remove_column :statistics, :putts_per_gir
  end
end
