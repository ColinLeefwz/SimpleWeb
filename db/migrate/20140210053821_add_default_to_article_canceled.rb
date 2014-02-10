class AddDefaultToArticleCanceled < ActiveRecord::Migration
  def change
    change_column :articles, :canceled, :boolean, default: false
    
    remove_column :articles, :price
  end
end
