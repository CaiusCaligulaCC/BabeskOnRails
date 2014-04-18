class CreateKuwasysCourses < ActiveRecord::Migration
  def up
    create_table :kuwasys_courses do |t|
      t.string :label, null: false
      t.string :description, limit: 1024
      t.integer :maxRegistration, limit: 5
      t.boolean :registrationEnabled
      t.integer :categoryId
      t.integer :schoolyearId

      t.timestamps
    end
  end

  def down
    drop_table :kuwasys_courses
  end
end
