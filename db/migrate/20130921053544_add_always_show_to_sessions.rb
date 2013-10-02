class AddAlwaysShowToSessions < ActiveRecord::Migration
  def change
    add_column :sessions, :always_show, :boolean, default: false
  end
end
