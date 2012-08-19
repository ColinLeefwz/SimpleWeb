class Clean2 < ActiveRecord::Migration
  def up
    execute "drop table blacklists"
    execute "drop table follows"
    execute "drop table user_logos"
    execute "drop table users"
    execute "drop table shop_notices"    
  end

  def down
  end
end
