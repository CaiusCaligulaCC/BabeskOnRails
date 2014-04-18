class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :firstname, limit: 64, null: false, default: ''
      t.string :lastname, limit: 64, null: false, default: ''
      t.date :birthday, null: false, default: '01-01-1900'
      t.integer :address_id
      t.integer :group_id

      t.timestamps
    end
  end
end
