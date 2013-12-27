class AlterSubscription < ActiveRecord::Migration
  def change
    change_table :subscriptions do |t|
      t.remove :subscribed_session_id
      t.references :subscribable, polymorphic: true
    end
  end
end
