class AddAdvantageTransformationToStatistics < ActiveRecord::Migration
  def change
    add_column :statistics, :advantage_transformation, :string, limit: 10, after: :bounce
  end
end
