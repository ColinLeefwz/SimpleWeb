class ChangeExpertIdToMemberId < ActiveRecord::Migration
  def change
    remove_reference :email_messages, :expert
    add_reference :email_messages, :user, index: true
  end
end
