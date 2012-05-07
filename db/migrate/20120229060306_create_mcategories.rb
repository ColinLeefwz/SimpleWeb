class CreateMcategories < ActiveRecord::Migration
  def self.up
    create_table :mcategories do |t|
      t.string :name, :null => false, :default => ''
      t.integer :nest_id, :null => false, :default => 0
      t.integer :mshop_count, :null => false, :default => 0
      t.string :dp_url, :null => false, :default => ''
      t.string :kb_url, :null => false, :default => ''

      t.timestamps
    end
  end

  def self.down
    drop_table :mcategories
  end
end
