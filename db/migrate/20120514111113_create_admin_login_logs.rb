class CreateAdminLoginLogs < ActiveRecord::Migration
  def self.up
    create_table :admin_login_logs do |t|
      t.integer "admin_id", :null => false
      t.timestamp "login_time", :null => false
      t.timestamp "logout_time"
      t.boolean :login_suc
      t.string :name
      t.string :password
      t.string :phone
      t.string "ip", :null => false
      t.string "session_id", :null => true
    end
    add_index :admin_login_logs, :admin_id
    execute "ALTER TABLE admin_login_logs ADD CONSTRAINT `FK_admin_accounts_admin_id` FOREIGN KEY `FK_admin_accounts_admin_id` (`admin_id`) REFERENCES `admins` (`id`);"
 
  end

  def self.down
    drop_table :admin_login_logs
  end
end
