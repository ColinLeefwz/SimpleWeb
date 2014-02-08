class AddAlwaysShowToAnnouncements < ActiveRecord::Migration
  def change
    add_column :announcements, :always_show, :boolean, default: false
  end
end
