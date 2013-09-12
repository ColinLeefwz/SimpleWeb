class AddImageUrlToSessions < ActiveRecord::Migration
  def change
    add_column :sessions, :image_url, :string , default: 'default.png'
  end
end
