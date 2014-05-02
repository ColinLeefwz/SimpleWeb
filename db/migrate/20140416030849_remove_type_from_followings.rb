class RemoveTypeFromFollowings < ActiveRecord::Migration
  def up
    remove_column :followings, :type
  end

  def down
    add_column :followings, :type, :string
  end
end
