class RemoveMshopCountDpUrlMcategoriesMdistricts < ActiveRecord::Migration
  def self.up
    remove_column :mcategories, :mshop_count
    remove_column :mcategories, :dp_url
    remove_column :mdistricts, :mshop_count
    remove_column :mdistricts, :dp_url
  end

  def self.down
    add_column :mcategories, :mshop_count, :integer, :null => false, :default => 0
    add_column :mcategories, :dp_url, :string, :null => false, :default => 0
    add_column :mdistricts, :mshop_count, :integer, :null => false, :default => 0
    add_column :mdistricts, :dp_url, :string, :null => false, :default => 0
  end
end
