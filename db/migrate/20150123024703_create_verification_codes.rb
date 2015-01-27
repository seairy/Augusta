class CreateVerificationCodes < ActiveRecord::Migration
  def change
    create_table :verification_codes do |t|
      t.references :user, null: false
      t.string :content, limit: 6, null: false
      t.boolean :available, default: true, null: false
      t.datetime :generated_at, null: false
      t.timestamps null: false
    end
  end
end
