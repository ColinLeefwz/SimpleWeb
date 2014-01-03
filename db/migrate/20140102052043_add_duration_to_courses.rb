class AddDurationToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :duration, :string
  end
end
