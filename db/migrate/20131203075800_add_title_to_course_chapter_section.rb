class AddTitleToCourseChapterSection < ActiveRecord::Migration
  def change
    add_column :courses, :title, :string
    add_column :chapters, :title, :string
    add_column :sections, :title, :string
  end
end
