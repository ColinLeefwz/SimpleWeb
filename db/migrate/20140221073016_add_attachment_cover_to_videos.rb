class AddAttachmentCoverToVideos < ActiveRecord::Migration
  def self.up
    change_table :videos do |t|
      t.attachment :cover
    end
  end

  def self.down
    drop_attached_file :videos, :cover
  end
end
