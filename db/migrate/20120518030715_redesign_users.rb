class RedesignUsers < ActiveRecord::Migration
  def self.up
    drop_table :users
    create_table :users do |t|
      t.integer :wb_uid
      t.string :screen_name
      t.string :name
      t.integer :province
      t.integr :city
      t.string :location
      t.string :description
      t.string :url 
      t.string :profile_image_url
      t.string :domain
      t.string :gender
      t.integer :followers_count
      t.integer :friends_count
      t.integer :statuses_count
      t.integer :favourites_count
      t.boolean :following
      t.boolean :allow_all_act_msg
      t.boolean :geo_enabled
      t.boolean :verified
      t.boolean :allow_all_comment
      t.string :avatar_large
      t.string :verified_reason
      t.boolean :follow_me
      t.interer :online_status
      t.interer :bi_followers_count




      t.timestamps
    end
  end

  def self.down
    drop_table :users
    create_table :users
  end
end
