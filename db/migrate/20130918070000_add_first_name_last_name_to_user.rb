class AddFirstNameLastNameToUser < ActiveRecord::Migration
  def change
    add_column :users, :username, :string
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
		remove_column :users, :rolable_id, :integer
		remove_column :users, :rolable_type, :string
		remove_column :users, :userable_id, :integer
		remove_column :users, :userable_type, :string
  end
end
