class AddStartDateToSession < ActiveRecord::Migration
  def change
    add_column :sessions, :start_date, :datetime
  end
end
