class AddMcityIdMshops < ActiveRecord::Migration
  def self.up
    add_column :mshops, :mcity_id, :integer, :null => false, :default => 0
  end

  def self.down
    remove_column :mshops, :mcity_id
  end
end
