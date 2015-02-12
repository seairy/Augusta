class AddStartedAtToMatches < ActiveRecord::Migration
  def change
    add_column :matches, :started_at, :datetime, null: false, after: :name
  end
end
