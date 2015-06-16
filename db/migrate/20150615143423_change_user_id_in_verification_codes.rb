class ChangeUserIdInVerificationCodes < ActiveRecord::Migration
  def change
    change_column :verification_codes, :user_id, :integer, null: true
  end
end
