class RenameCoursesToVenues < ActiveRecord::Migration
  def change
    rename_table :courses, :venues
  end
end
