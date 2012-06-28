class CreateBlacklists < ActiveRecord::Migration
  def change
    create_table :blacklists do |t|
      t.integer :user_id, :null => false
      t.integer :block_id, :null => false
      t.boolean :report, :default => false
      t.timestamps
    end
    
    add_index :blacklists, :user_id
    add_index :blacklists, :block_id
    add_index :blacklists, [:user_id, :block_id],:unique => true
    
  end
end
