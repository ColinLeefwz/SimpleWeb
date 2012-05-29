class AddCommentCountAndSourceMshops < ActiveRecord::Migration
  def self.up
    add_column :mshops, :comment_count, :integer,:default => 0
  end

  def self.down
    remove_column :mshops, :comment_count
  end
end
