class CreateMshopMdistricts < ActiveRecord::Migration
  def self.up
    create_table :mshop_mdistricts do |t|
      t.integer :mshop_id, :null => false, :default => 0
      t.integer :mdistrict_id, :null => false, :default => 0

      t.timestamps
    end
  end

  def self.down
    drop_table :mshop_mdistricts
  end
end
