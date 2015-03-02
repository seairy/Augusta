class CreateStatistics < ActiveRecord::Migration
  def change
    create_table :statistics do |t|
      t.references :match, null: false
      t.string :score, limit: 10
      t.string :net, limit: 10
      t.string :putts, limit: 10
      t.string :penalties, limit: 10
      t.string :average_driver_length, limit: 10
      t.string :drive_fairways_hit, limit: 10
      t.string :greens_in_regulation, limit: 10
      t.string :putts_per_gir, limit: 10
      t.string :score_par_3, limit: 10
      t.string :score_par_4, limit: 10
      t.string :score_par_5, limit: 10
      t.string :double_eagle, limit: 10
      t.string :eagle, limit: 10
      t.string :birdie, limit: 10
      t.string :par, limit: 10
      t.string :bogey, limit: 10
      t.string :double_bogey, limit: 10
      t.timestamps null: false
    end
  end
end
