# -*- encoding : utf-8 -*-
class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :uuid, limit: 36, null: false
      t.string :phone, limit: 20, null: false
      t.string :nickname, limit: 50
      t.string :portrait, limit: 191
      t.integer :gender, limit: 1
      t.date :birthday
      t.string :description, limit: 191
      t.integer :handicap, limit: 2
      t.datetime :signed_up_at
      t.datetime :current_sign_in_at, :last_signed_in_at
      t.string :state, limit: 20, null: false
      t.timestamps null: false
    end
  end
end
