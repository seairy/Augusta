class CreateFeedbacks < ActiveRecord::Migration
  def change
    create_table :feedbacks do |t|
      t.references :user, null: false
      t.text :content, null: false
      t.timestamps null: false
    end
  end
end
