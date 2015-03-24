class AddScramblesToStatistics < ActiveRecord::Migration
  def change
    add_column :statistics, :scrambles, :string, limit: 10, after: :drive_fairways_hit
  end
end
