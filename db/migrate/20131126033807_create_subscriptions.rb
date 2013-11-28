class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.references :subscriber, index: true
      t.references :subscribed_session, index: true

      t.timestamps
    end
  end
end
