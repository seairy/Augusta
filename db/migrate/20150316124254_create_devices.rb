class CreateDevices < ActiveRecord::Migration
  def change
    create_table :devices do |t|
      t.references :user, null: false
      t.string :platform_cd, limit: 20, null: false
      t.string :identity, limit: 100
      t.string :name, limit: 100
      t.string :os_version, limit: 50
      t.datetime :last_signed_in_at, null: false
      t.timestamps null: false
    end
  end
end
