class AddImageUrlToExpert < ActiveRecord::Migration
  def change
    add_column :experts, :image_url, :string, default: 'default.png'
  end
end
