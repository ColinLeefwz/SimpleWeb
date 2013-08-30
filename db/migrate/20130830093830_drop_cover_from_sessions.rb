class DropCoverFromSessions < ActiveRecord::Migration
  def change
    remove_column :sessions, :cover
  end
end
