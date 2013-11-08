class AddCanceledToSession < ActiveRecord::Migration
  def change
    add_column :sessions, :canceled, :boolean
  end
end
