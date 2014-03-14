class AddDefaultToAnnouncementDescription < ActiveRecord::Migration
  def change
    change_column :announcements, :description, :text, default: "  "
  end
end
