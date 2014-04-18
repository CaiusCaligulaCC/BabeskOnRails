class CreateKuwasysRegistrations < ActiveRecord::Migration
  def change
    create_table :kuwasys_registrations do |t|
      t.integer :user_id
      t.integer :course_id
      t.integer :status_id

      t.timestamps
    end
  end
end
