class CreateMshops < ActiveRecord::Migration
  def self.up
    create_table :mshops do |t|
      t.string :name, :null => false, :default => ''
      t.string :fullname, :null => false, :default => ''
      t.string :address, :null => false, :default => ''
      t.string :phone, :null => false, :default => ''
      t.string :linkman, :null => false, :default => ''
      t.string :kb_id, :null => false, :default => '', :limit => 32
      t.integer :dp_id, :null => false, :default => 0
      t.decimal :lat, :precision => 11, :scale => 7, :null => false, :default => 0.00
      t.decimal :lng, :precision => 11, :scale => 7, :null => false,  :default => 0.00

      t.timestamps
    end
  end

  def self.down
    drop_table :mshops
  end
end
