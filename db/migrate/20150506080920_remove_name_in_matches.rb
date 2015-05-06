class RemoveNameInMatches < ActiveRecord::Migration
  def change
    remove_column :matches, :name
  end
end
