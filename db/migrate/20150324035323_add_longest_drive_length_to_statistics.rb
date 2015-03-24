class AddLongestDriveLengthToStatistics < ActiveRecord::Migration
  def change
    add_column :statistics, :longest_drive_length, :string, limit: 10, after: :penalties
  end
end
