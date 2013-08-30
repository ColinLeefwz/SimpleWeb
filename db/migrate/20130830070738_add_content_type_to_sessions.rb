class AddContentTypeToSessions < ActiveRecord::Migration
  def change
    add_column :sessions, :content_type, :string
  end
end
