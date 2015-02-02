# -*- encoding : utf-8 -*-
class CreateTokens < ActiveRecord::Migration
  def change
    create_table :tokens do |t|
      t.references :user, null: false
      t.string :content, limit: 22, null: false
      t.boolean :available, default: true, null: false
      t.datetime :generated_at, null: false
      t.timestamps null: false
    end
    add_index :tokens, :user_id
  end
end
