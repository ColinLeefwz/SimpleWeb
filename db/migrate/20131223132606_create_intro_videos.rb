class CreateIntroVideos < ActiveRecord::Migration
  def change
    create_table :intro_videos do |t|
      t.string :hd_url
      t.string :sd_url
			t.references :course, index: true

			t.attachment :attached_video_hd
			t.attachment :attached_video_sd

      t.timestamps
    end
  end
end
