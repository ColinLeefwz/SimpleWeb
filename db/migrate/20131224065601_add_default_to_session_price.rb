class AddDefaultToSessionPrice < ActiveRecord::Migration
  def change
    change_column :sessions, :price, :decimal, default: 0.0
  end
end
