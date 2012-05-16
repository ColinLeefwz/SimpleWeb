class CreateRights < ActiveRecord::Migration
  def self.up
    create_table :rights do |t|
      t.integer :admin_id
      t.integer :depart_id
      t.integer :role_id
      t.string :tables
      t.string :operate

      t.timestamps
    end
  end

  def self.down
    drop_table :rights
  end
end
