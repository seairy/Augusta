class CreateLeaderboards < ActiveRecord::Migration
  def change
    create_table :leaderboards do |t|
      t.references :match, null: false
      t.references :player, null: false
      t.string :position, limit: 5
      t.string :thru, limit: 10
      t.integer :strokes
      t.integer :total
      t.timestamps null: false
    end
  end
end
