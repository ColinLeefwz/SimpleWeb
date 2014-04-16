class DropOldFollowingsTable < ActiveRecord::Migration
  def up
    drop_table :followings if self.table_exists?("followings")
  end

  def down
    create_table :followings do |t|
      t.timestamps
    end
  end
end
