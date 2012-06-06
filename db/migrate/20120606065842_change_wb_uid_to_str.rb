class ChangeWbUidToStr < ActiveRecord::Migration
  def up
    change_column :users, :wb_uid, :string
  end

  def down
    change_column :users, :wb_uid, :integer
  end
end
