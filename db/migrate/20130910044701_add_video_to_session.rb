class AddVideoToSession < ActiveRecord::Migration
  def change
		add_attachment :sessions, :video
  end
end
