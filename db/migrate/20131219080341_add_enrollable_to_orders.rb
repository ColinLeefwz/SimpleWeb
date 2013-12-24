class AddEnrollableToOrders < ActiveRecord::Migration
  def self.up
    remove_column :orders, :session_id
    add_column :orders, :enrollable_id, :integer
    add_column :orders, :enrollable_type, :string
  end

  def self.down
    add_column :orders, :session_id, :integer
    remove_column :orders, :enrollable_type
    remove_column :orders, :enrollable_id
  end
end
