class RenameRelationsToFollowings < ActiveRecord::Migration
  def self.up
    rename_table :relationships, :followings
  end

  def self.down
    rename_table :followings, :relationships
  end
end
