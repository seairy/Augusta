class AddRemarkToMatches < ActiveRecord::Migration
  def change
    add_column :matches, :remark, :text, after: :password
  end
end
