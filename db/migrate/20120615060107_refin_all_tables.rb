class RefinAllTables < ActiveRecord::Migration
  def up
    change_column :admins, :name, :string, :limit => 32, :null => false
    change_column :admins, :password, :string, :limit => 32, :null => false

    change_column :checkins, :ip, :string, :limit => 64
    change_column :checkins, :shop_name, :string, :limit => 64
    add_index :checkins, :ip

    change_column :departs, :name, :string, :limit => 32, :null => false

    change_column :roles, :name, :string, :limit => 32, :null => false
    
    change_column :users, :wb_uid, :string, :limit => 64
    change_column :users, :name, :string, :limit => 64
    change_column :users, :birthday, :string, :limit => 32
    #    add_index :users,:wb_uid # 已经存在
    add_index :users,:name
    add_index :users, :gender


    #    add_index :follows, :user_id # 已经存在
    #    add_index :follows, :follow_id # 已经存在

  end

  def down
  end
end
