class CreateMshopMcategories < ActiveRecord::Migration
  def self.up
    create_table :mshop_mcategories do |t|
      t.integer :mshop_id, :null => false, :default => 0
      t.integer :mcategory_id, :null => false, :default => 0

      t.timestamps
    end
  end

  def self.down
    drop_table :mshop_mcategories
  end
end
