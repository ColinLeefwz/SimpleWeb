class CreateUserLoginLogs < ActiveRecord::Migration
  def self.up
    create_table "user_login_logs", :force => true do |t|
      t.datetime "login_time",               :null => false
      t.string   "ip",                       :null => false
      t.string   "name",       :limit => 26
      t.string   "phone",      :limit => 15
      t.string   "password",   :limit => 26
      t.boolean  "login_suc"
      t.integer  "user_id"
    end
  end

  def self.down
    drop_table :user_login_logs
  end
end
