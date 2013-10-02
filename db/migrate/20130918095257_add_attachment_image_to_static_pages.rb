class AddAttachmentImageToStaticPages < ActiveRecord::Migration
  def self.up
    add_attachment :static_pages, :image
  end

  def self.down
    remove_attachment :static_pages, :image
  end
end
