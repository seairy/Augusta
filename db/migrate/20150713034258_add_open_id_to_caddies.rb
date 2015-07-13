class AddOpenIdToCaddies < ActiveRecord::Migration
  def change
    add_column :caddies, :open_id, :string, limit: 512, null: false, after: :uuid
  end
end
