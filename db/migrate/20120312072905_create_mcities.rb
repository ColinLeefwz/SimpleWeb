class CreateMcities < ActiveRecord::Migration
  def self.up
    create_table :mcities do |t|
      t.integer :dp_id, :null => false, :default => 0
      t.string :kb_id, :null => false, :default => '', :limit => 32
      t.string :name, :null => false, :default => '', :limit => 50
      t.string :eng_name, :null => false, :default => '', :limit => 50
      t.boolean :crawled, :null => false, :default => false
      t.timestamp :started_at
      t.timestamp :ended_at

      t.timestamps
    end
  end

  def self.down
    drop_table :mcities
  end
end
