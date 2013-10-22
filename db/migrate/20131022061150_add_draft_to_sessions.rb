class AddDraftToSessions < ActiveRecord::Migration
  def change
    add_column :sessions, :draft, :boolean
  end
end
