class CreateFollowings < ActiveRecord::Migration
  def change
    create_table :followings do |t|
      t.integer :the_followed, index: true
      t.integer :follower, index: true

      t.timestamps
    end
  end
end
