class AddTypeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :type_cd, :string, limit: 20, null: false, after: :uuid
  end
end
