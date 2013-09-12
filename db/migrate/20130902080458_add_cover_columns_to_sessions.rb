class AddCoverColumnsToSessions < ActiveRecord::Migration

  def up
      add_attachment :sessions, :cover
  end

  def down 
      remove_attachment :sessions, :cover
  end
end
