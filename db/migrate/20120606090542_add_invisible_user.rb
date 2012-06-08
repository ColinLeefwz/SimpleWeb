class AddInvisibleUser < ActiveRecord::Migration
  def change
    add_column :users, :invisible, :integer, :default => 0
  end

end
