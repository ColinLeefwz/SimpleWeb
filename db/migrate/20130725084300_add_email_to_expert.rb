class AddEmailToExpert < ActiveRecord::Migration
  def change
    add_column :experts, :email, :string
  end
end
