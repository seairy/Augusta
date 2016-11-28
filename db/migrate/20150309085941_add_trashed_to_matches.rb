class AddTrashedToMatches < ActiveRecord::Migration
  def change
    add_column :matches, :trashed, :boolean, default: false, null: false, after: :started_at
  end
end
