class AddTypeCdToVerificationCodes < ActiveRecord::Migration
  def change
    add_column :verification_codes, :type_cd, :string, limit: 20, null: false, after: :user_id
  end
end
