class AddHdSdUrlToVideoInterview < ActiveRecord::Migration
  def change
		add_column :video_interviews, :hd_url, :string
		add_column :video_interviews, :sd_url, :string
  end
end
