class AddUserInfo < ActiveRecord::Migration
  def change
    add_column :users, :signature, :string
    add_column :users, :job, :string
    add_column :users, :jobtype, :integer
    add_column :users, :hobby, :string
  end

end
