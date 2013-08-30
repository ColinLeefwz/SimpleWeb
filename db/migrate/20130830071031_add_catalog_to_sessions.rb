class AddCatalogToSessions < ActiveRecord::Migration
  def change
    add_column :sessions, :catalog, :string
  end
end
