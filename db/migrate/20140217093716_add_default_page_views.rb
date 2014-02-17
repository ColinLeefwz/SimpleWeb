class AddDefaultPageViews < ActiveRecord::Migration
  def change
    change_column :visits, :page_views, :integer, default: 0
  end
end
