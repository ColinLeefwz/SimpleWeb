class AddDurationToChapters < ActiveRecord::Migration
  def change
    add_column :chapters, :duration, :string
  end
end
