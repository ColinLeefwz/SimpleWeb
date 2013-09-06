class DropCatalogFromSessions < ActiveRecord::Migration
  def change
    remove_column :sessions, :catalog, :string
    add_column :sessions, :category, :string
  end
end
