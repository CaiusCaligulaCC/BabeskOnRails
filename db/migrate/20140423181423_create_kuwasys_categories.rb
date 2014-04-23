class CreateKuwasysCategories < ActiveRecord::Migration
  def change
    create_table :kuwasys_categories do |t|
      t.string :name, limit: 128

      t.timestamps
    end
  end
end
