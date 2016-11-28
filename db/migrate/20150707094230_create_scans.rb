class CreateScans < ActiveRecord::Migration
  def change
    create_table :scans do |t|
      t.string :source, limit: 50
      t.string :ip, limit: 20
      t.string :platform, limit: 15
      t.timestamps null: false
    end
  end
end
