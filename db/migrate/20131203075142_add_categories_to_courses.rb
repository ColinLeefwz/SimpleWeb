class AddCategoriesToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :categories, :string, array: true, default: '{}'
    add_index :courses, :categories, using: 'gin'
  end
end
