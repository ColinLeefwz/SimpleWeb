class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      t.text :description

      t.timestamps
    end
  end
end
