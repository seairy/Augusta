class IndexAvailableAndContentToTokens < ActiveRecord::Migration
  def change
    add_index :tokens, [:available, :content]
  end
end
