class CreateMdistricts < ActiveRecord::Migration
  def self.up
    create_table :mdistricts do |t|
      t.string :name, :null => false, :default => ''
      t.integer :nest_id, :null => false, :default => 0
      t.integer :mshop_count, :null => false, :default => 0
      t.string :dp_url, :null => false, :default => ''
      t.string :kb_url, :null => false, :default => ''

      t.timestamps
    end
  end

  def self.down
    drop_table :mdistricts
  end
end
