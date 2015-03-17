class RenameGroupIdToCourseIdInHoles < ActiveRecord::Migration
  def change
    rename_column :holes, :group_id, :course_id
  end
end
