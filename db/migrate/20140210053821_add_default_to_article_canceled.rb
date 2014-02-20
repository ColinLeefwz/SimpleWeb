class AddDefaultToArticleCanceled < ActiveRecord::Migration
  def up
    change_column :articles, :canceled, :boolean, default: false
    remove_column :articles, :price
  end

  def down
  end
end
