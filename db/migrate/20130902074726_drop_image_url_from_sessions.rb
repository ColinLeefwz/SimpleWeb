class DropImageUrlFromSessions < ActiveRecord::Migration
  def up
      remove_column :sessions, :image_url 
  end

  def down
      add_column :sessions, :image_url, :string, default: "default.png"
  end
end
