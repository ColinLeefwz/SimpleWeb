class CreateAccessLogs < ActiveRecord::Migration
  def self.up
    create_table :access_logs do |t|
      t.integer :user_id
      t.integer :shop_id
      t.integer :admin_id
      t.string :session_id,  :length => 64
      t.integer :mem_consume
      t.integer :mem_now
      t.integer :time
      t.string :url,  :length => 100
      t.string :ip, :length => 25
      t.timestamps
    end
  end

  def self.down
    drop_table :access_logs
  end
end
