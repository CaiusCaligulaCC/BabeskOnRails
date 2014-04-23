class RenameCourseUppercaseIdsToLowercase < ActiveRecord::Migration
  def up
    rename_column :kuwasys_courses, :categoryId, :category_id
    rename_column :kuwasys_courses, :schoolyearId, :schoolyear_id
  end

  def down
    rename_column :kuwasys_courses, :category_id, :categoryId
    rename_column :kuwasys_courses, :schoolyear_id, :schoolyearId
  end
end
