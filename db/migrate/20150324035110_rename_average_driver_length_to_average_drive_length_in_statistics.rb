class RenameAverageDriverLengthToAverageDriveLengthInStatistics < ActiveRecord::Migration
  def change
    rename_column :statistics, :average_driver_length, :average_drive_length
  end
end
