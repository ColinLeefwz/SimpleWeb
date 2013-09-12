class AddAuthorizedToExpert < ActiveRecord::Migration
  def change
    add_column :experts, :authorized, :bool, default: false
  end
end
