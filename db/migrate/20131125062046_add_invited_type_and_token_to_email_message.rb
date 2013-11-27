class AddInvitedTypeAndTokenToEmailMessage < ActiveRecord::Migration
  def change
    add_column :email_messages, :invited_type, :string
    add_column :email_messages, :invite_token, :string
  end
end
