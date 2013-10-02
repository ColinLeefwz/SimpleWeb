class AddOauthColumnsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :provider, :string
    add_column :users, :uid, :string
		rename_column :users, :username, :name
  end
end
