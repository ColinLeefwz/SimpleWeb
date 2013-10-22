class AddDraftToSessions < ActiveRecord::Migration
  def change
    add_column :sessions, :draft, :boolean, default: false
  end
end
