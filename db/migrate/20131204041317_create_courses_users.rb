class CreateCoursesUsers < ActiveRecord::Migration
  def change
    create_table :courses_users do |t|
      t.references :course, index: true
      t.references :expert, index: true
    end
  end
end
