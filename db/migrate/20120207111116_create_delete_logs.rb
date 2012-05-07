class CreateDeleteLogs < ActiveRecord::Migration
  def self.up
    create_table :delete_logs do |t|
      t.integer :object_id
      t.string :model
      t.string :yaml

      t.timestamps
    end
  end

  def self.down
    drop_table :delete_logs
  end
end
