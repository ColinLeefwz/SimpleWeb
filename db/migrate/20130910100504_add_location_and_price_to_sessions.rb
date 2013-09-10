class AddLocationAndPriceToSessions < ActiveRecord::Migration
  def change
    add_column :sessions, :location, :string
    add_column :sessions, :price, :decimal
  end
end
