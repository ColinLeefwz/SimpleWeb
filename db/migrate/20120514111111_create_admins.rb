class CreateAdmins < ActiveRecord::Migration
  def self.up
    create_table :admins do |t|
      t.string :name
      t.string :password
      t.string :clazz
      t.integer :depart_id

      t.timestamps
    end
    execute "insert into admins (name,password) values ('root','root')"
  end

  def self.down
    drop_table :admins
  end
end
