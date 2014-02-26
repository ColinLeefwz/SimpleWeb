class AddAttachmentSdToVideos < ActiveRecord::Migration
  def self.up
    change_table :videos do |t|
      t.attachment :SD
    end
  end

  def self.down
    drop_attached_file :videos, :SD
  end
end
