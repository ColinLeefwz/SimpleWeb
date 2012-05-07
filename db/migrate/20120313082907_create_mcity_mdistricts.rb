class CreateMcityMdistricts < ActiveRecord::Migration
  def self.up
    create_table :mcity_mdistricts do |t|
      t.integer :mcity_id, :null => false, :default => 0
      t.integer :mdistrict_id, :null => false, :default => 0
      t.string :dp_url, :null => false, :default => ''
      t.integer :mshop_count, :null => false, :default => 0

      t.timestamps
    end
  end

  def self.down
    drop_table :mcity_mdistricts
  end
end
