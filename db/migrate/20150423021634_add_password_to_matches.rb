class AddPasswordToMatches < ActiveRecord::Migration
  def change
    add_column :matches, :password, :string, limit: 4, after: :name
  end
end
