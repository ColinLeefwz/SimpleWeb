class RenameSessionsTable < ActiveRecord::Migration
  def change
    remove_column :sessions, :status
    remove_column :sessions, :content_type
    remove_column :sessions, :video_url
    remove_attachment :sessions, :video
    remove_column :sessions, :location
    remove_column :sessions, :start_date
    remove_column :sessions, :end_date_time

    rename_table :sessions, :articles
  end
end
