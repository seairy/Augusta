class RenameGroupsCountToCoursesCountInVenues < ActiveRecord::Migration
  def change
    rename_column :venues, :groups_count, :courses_count
  end
end
