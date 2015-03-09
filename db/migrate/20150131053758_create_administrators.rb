# -*- encoding : utf-8 -*-
class CreateAdministrators < ActiveRecord::Migration
  def change
    create_table :administrators do |t|
      t.string :account, limit: 32, null: false
      t.string :hashed_password, limit: 100, null: false
      t.string :name, limit: 100, null: false
      t.boolean :available, null: false
      t.string :token, limit: 22, null: false
      t.datetime :last_signined_at, :current_signined_at
      t.boolean :trashed, default: false, null: false
      t.timestamps null: false
    end
  end
end
