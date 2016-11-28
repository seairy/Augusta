class AddPasswordExpiredAtToMatches < ActiveRecord::Migration
  def change
    add_column :matches, :password_expired_at, :datetime, after: :password
  end
end
