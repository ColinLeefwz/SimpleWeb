class SimplifyUser < ActiveRecord::Migration
  def self.up
    drop_table :users
    create_table :users do |t|
      t.integer :wb_uid
      t.string :name
      t.string :gender
      t.string :birthday
      t.string :password
      t.timestamps
    end
  end

  def self.down
    drop_table :users
    create_table :users
  end
  
end
