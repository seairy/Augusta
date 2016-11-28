class RenameCourseIdToVenueIdInMatches < ActiveRecord::Migration
  def change
    rename_column :matches, :course_id, :venue_id
  end
end
