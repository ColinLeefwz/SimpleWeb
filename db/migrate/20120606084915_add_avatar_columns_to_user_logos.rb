class AddAvatarColumnsToUserLogos < ActiveRecord::Migration
  def self.up
    add_column :user_logos, :avatar_file_name,    :string
    add_column :user_logos, :avatar_content_type, :string
    add_column :user_logos, :avatar_file_size,    :integer
    add_column :user_logos, :avatar_updated_at,   :datetime
  end

  def self.down
    remove_column :user_logos, :avatar_file_name
    remove_column :user_logos, :avatar_content_type
    remove_column :user_logos, :avatar_file_size
    remove_column :user_logos, :avatar_updated_at
  end


end
