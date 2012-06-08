class AddUniqueIndexWbUid < ActiveRecord::Migration
  def up
    add_index :users, :wb_uid, :unique => true
  end

  def down
    remove_index :users, :wb_uid
  end
end
