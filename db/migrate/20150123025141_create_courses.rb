class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      t.string :uuid, limit: 36, null: false
      t.string :name, limit: 191, null: false
      t.timestamps null: false
    end
  end
end
