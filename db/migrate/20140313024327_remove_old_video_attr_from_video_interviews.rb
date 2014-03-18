class RemoveOldVideoAttrFromVideoInterviews < ActiveRecord::Migration
  def change
    remove_column :video_interviews, :attached_video_hd_file_name
    remove_column :video_interviews, :attached_video_hd_content_type
    remove_column :video_interviews, :attached_video_hd_file_size
    remove_column :video_interviews, :attached_video_hd_updated_at

    remove_column :video_interviews, :attached_video_sd_file_name
    remove_column :video_interviews, :attached_video_sd_content_type
    remove_column :video_interviews, :attached_video_sd_file_size
    remove_column :video_interviews, :attached_video_sd_updated_at

    remove_column :video_interviews, :hd_url
    remove_column :video_interviews, :sd_url

    remove_column :video_interviews, :cover_url
  end
end
