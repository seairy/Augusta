# -*- encoding : utf-8 -*-
class CreateMatches < ActiveRecord::Migration
  def change
    create_table :matches do |t|
      t.string :uuid, limit: 36, null: false
      t.references :owner, null: false
      t.references :course, null: false
      t.string :type_cd, limit: 20, null: false
      t.string :name, limit: 100
      t.timestamps null: false
    end
  end
end
