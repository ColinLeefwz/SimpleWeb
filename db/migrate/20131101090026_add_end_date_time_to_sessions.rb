class AddEndDateTimeToSessions < ActiveRecord::Migration
  def change
    add_column :sessions, :end_date_time, :datetime
  end
end
