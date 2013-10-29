class AddDefaultTimeZone < ActiveRecord::Migration
  def change
    change_column_default(:sessions, :time_zone, "UTC")
    change_column_default(:users, :time_zone, "UTC")
  end
end
