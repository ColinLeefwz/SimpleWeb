class CreateCheckins < ActiveRecord::Migration
  def change
    create_table :checkins do |t|
      t.integer :mshop_id
      t.integer :user_id
      t.string :ip
      t.timestamp :time
      t.float :lat
      t.float :lng
      t.string :shop_name

      t.timestamps
    end
  end
end
