class RemoveOldVideoAttrFromAnnouncements < ActiveRecord::Migration
  def change
    remove_column :announcements, :attached_video_hd_file_name
    remove_column :announcements, :attached_video_hd_content_type
    remove_column :announcements, :attached_video_hd_file_size
    remove_column :announcements, :attached_video_hd_updated_at

    remove_column :announcements, :attached_video_sd_file_name
    remove_column :announcements, :attached_video_sd_content_type
    remove_column :announcements, :attached_video_sd_file_size
    remove_column :announcements, :attached_video_sd_updated_at

    remove_column :announcements, :hd_url
    remove_column :announcements, :sd_url
  end
end
