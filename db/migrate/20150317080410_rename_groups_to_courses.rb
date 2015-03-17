class RenameGroupsToCourses < ActiveRecord::Migration
  def change
    rename_table :groups, :courses
  end
end
