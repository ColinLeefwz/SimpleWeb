class AddSubscribedToUsers < ActiveRecord::Migration
  def change
    add_column :users, :subscribe_newsletter, :boolean, default: true
  end
end
