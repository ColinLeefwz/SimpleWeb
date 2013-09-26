class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.references :user, index: true
      t.references :session, index: true
      t.string :payment_id
      t.string :state
      t.string :amount
      t.string :description

      t.timestamps
    end
  end
end
