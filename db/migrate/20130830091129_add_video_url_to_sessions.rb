class AddVideoUrlToSessions < ActiveRecord::Migration
  def change
    add_column :sessions, :video_url, :string
  end
end
