class RemoveNameInMatches < ActiveRecord::Migration
  def change
    remove_column :matches, :name, :string, limit: 100
  end
end
