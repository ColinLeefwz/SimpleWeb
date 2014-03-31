class AddUserNameToUsers < ActiveRecord::Migration
  def change
    unless column_exists?(:users, :user_name)
      add_column :users, :user_name, :string
    end

    if column_exists?(:users, :name)
      remove_column :users, :name
    end

    if column_exists? :users, :subdomain
      remove_column :users, :subdomain
    end
  end
end
