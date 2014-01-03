class ChangeWebSiteColumnType < ActiveRecord::Migration
  def change
    change_column :profiles, :web_site, :string
  end
end
