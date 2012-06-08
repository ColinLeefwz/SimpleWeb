class ChangeGender < ActiveRecord::Migration
  def up
    change_column :users, :gender , :integer , :default => 0
  end

  def down
    change_column :users, :gender , :string
  end
end
