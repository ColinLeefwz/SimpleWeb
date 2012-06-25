class AddIndexFollows < ActiveRecord::Migration
  def up
#    remove_index :follows, :user_id
#    remove_index :follows, :follow_id
    add_index :follows, [:user_id, :follow_id],:unique => true
  end

  def down
   # remove_index :follows, :column => [:user_id, :follow_id]
  end
end
