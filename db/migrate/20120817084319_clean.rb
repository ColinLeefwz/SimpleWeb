class Clean < ActiveRecord::Migration
  
  def try_drop(table)
    begin
      execute "drop table  #{table}"
    rescue  Exception => error
      puts error
    end      
  end
  
  def up
    try_drop 'access_201205logs'
    try_drop 'access_201206logs'
    try_drop 'access_logs'
    try_drop 'admin_login_logs'
    try_drop 'delete_logs'
    try_drop 'user_login_logs'
    try_drop 'checkins'
    try_drop 'sina_users'   
  end

  def down
  end
end
