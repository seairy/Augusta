class RenameCourseIdToVenueIdInCourses < ActiveRecord::Migration
  def change
    rename_column :courses, :course_id, :venue_id
  end
end
