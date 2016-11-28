class AddBounceToStatistics < ActiveRecord::Migration
  def change
    add_column :statistics, :bounce, :string, limit: 10, after: :scrambles
  end
end
