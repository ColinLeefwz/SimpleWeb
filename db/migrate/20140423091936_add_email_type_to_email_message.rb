class AddEmailTypeToEmailMessage < ActiveRecord::Migration
  def change
    add_column :email_messages, :email_type, :string
  end
end
