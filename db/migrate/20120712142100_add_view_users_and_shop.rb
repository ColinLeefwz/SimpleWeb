class AddViewUsersAndShop < ActiveRecord::Migration
  def up
    sql = "
    create view view_users as
    select id as username, password, name, 'u' as type from users
    union
    select concat('s',id) as username, 'pass' as password, name, 's' as type from mshops;"
    #execute sql
  end

  def down
    #execute "drop view view_users"
  end
end
