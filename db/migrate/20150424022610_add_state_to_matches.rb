class AddStateToMatches < ActiveRecord::Migration
  def change
    add_column :matches, :state, :string, limit: 20, null: false, after: :players_count
  end
end
