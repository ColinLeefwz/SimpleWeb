class CreateSessionUserTable < ActiveRecord::Migration
  def change
    create_table :sessions_users do |t|
			t.belongs_to :user
			t.belongs_to :session
    end
  end
end
