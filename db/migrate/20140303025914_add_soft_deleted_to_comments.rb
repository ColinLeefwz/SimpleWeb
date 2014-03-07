class AddSoftDeletedToComments < ActiveRecord::Migration
  def change
    add_column :comments, :soft_deleted, :boolean, default: false
  end
end
