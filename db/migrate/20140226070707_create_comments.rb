class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.references :user, index: true
      t.string :commentable_type
      t.integer :commentable_id
      t.timestamps
    end

    add_index :comments, [:commentable_type, :commentable_id]
  end
end

