class DropAuthorizedFromExperts < ActiveRecord::Migration
  def change
    remove_column :experts, :authorized, :boolean
  end
end
