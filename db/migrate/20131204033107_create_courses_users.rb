class CreateCoursesUsers < ActiveRecord::Migration
  def change
    create_table :courses_users do |t|
      t.references :courses, index: true
      t.references :experts, index: true
    end
  end
end
