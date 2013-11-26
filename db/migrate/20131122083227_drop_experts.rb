class DropExperts < ActiveRecord::Migration
  def change
    drop_table :experts if table_exists?(:experts)
  end
end
