class RenameLabelToName < ActiveRecord::Migration
  def up
    rename_column :kuwasys_courses, :label, :name
  end

  def down
    rename_column :kuwasys_courses, :name, :label
  end
end
