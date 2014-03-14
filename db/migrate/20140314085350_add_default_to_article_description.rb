class AddDefaultToArticleDescription < ActiveRecord::Migration
  def change
    change_column :articles, :description, :text, default: "  "
  end
end
