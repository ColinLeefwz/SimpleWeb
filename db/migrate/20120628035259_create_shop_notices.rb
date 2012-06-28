class CreateShopNotices < ActiveRecord::Migration
  def change
    create_table :shop_notices do |t|
      t.integer :shop_id
      t.string :title
      t.time :begin
      t.time :end
      t.decimal :ord, :precision => 10, :scale => 2
      t.timestamps
    end
  end
end
