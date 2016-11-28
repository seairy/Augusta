class AddCaddieIdToVerificationCodes < ActiveRecord::Migration
  def change
    add_column :verification_codes, :caddie_id, :integer, after: :user_id
  end
end
