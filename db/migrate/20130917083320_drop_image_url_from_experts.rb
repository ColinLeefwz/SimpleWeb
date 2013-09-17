class DropImageUrlFromExperts < ActiveRecord::Migration
  def change
    remove_column :experts, :image_url, :string
  end
end
