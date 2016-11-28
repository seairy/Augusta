class AddRuleCdToMatches < ActiveRecord::Migration
  def change
    add_column :matches, :rule_cd, :string, limit: 20, after: :password
  end
end
