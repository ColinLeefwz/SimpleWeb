class AddTimeZoneToSessions < ActiveRecord::Migration
  def change
    add_column :sessions, :time_zone, :string
  end
end
