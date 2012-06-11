class RemoveColumnsUserLogos < ActiveRecord::Migration
  def up
    remove_column :user_logos, :parent_id, :content_type, :filename, :thumbnail, :size, :width, :height
  end

  def down
    add_column :user_logos, :parent_id, :integer
    add_column :user_logos, :content_type, :string
    add_column :user_logos, :filename, :string
    add_column :user_logos, :thumbnail, :string
    add_column :user_logos, :size, :integer
    add_column :user_logos, :width, :integer
    add_column :user_logos, :height, :integer
  end
end
