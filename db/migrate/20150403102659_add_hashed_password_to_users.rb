class AddHashedPasswordToUsers < ActiveRecord::Migration
  def change
    add_column :users, :hashed_password, :string, limit: 32, after: :phone
  end
end
