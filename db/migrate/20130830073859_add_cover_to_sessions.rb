class AddCoverToSessions < ActiveRecord::Migration
  def change
    add_column :sessions, :cover, :string
  end
end
