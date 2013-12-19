class AddLanguageCoverToVideoInterview < ActiveRecord::Migration
  def change
		add_column :video_interviews, :language, :string
		add_attachment :video_interviews, :cover
		add_column :video_interviews, :cover_url, :string
  end
end
