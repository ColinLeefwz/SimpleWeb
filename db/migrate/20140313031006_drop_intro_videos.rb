class DropIntroVideos < ActiveRecord::Migration
  def change
    drop_table :intro_videos
  end
end
