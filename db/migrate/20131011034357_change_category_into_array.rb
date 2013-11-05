class ChangeCategoryIntoArray < ActiveRecord::Migration
  def change
    remove_column :sessions, :category, :string
    add_column :sessions, :categories, :string, array: true, default: '{}'
    add_index :sessions, :categories, using: 'gin'
  end
end
