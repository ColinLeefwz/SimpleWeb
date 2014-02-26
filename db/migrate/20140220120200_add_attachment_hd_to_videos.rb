class AddAttachmentHdToVideos < ActiveRecord::Migration
  def self.up
    change_table :videos do |t|
      t.attachment :HD
    end
  end

  def self.down
    drop_attached_file :videos, :HD
  end
end
