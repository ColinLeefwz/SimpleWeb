class AddSubdomainToUser < ActiveRecord::Migration
  def change
    add_column :users, :subdomain, :string
  end
end
