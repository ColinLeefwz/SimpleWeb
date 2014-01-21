class AddCoverToIntroVideos < ActiveRecord::Migration
  def change
    add_attachment :intro_videos, :cover
  end
end
