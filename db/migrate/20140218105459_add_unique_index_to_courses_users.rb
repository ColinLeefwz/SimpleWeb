class AddUniqueIndexToCoursesUsers < ActiveRecord::Migration
  def change
    add_index :courses_users, [:course_id, :expert_id], unique: true
  end
end
