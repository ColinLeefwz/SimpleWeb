class ChangeGeoDecimal < ActiveRecord::Migration
  def change
    change_column :checkins, :lat, :decimal, :precision => 11, :scale => 7
    change_column :checkins, :lng, :decimal, :precision => 11, :scale => 7
  end

end
