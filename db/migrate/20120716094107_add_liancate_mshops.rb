class AddLiancateMshops < ActiveRecord::Migration
  def change
    add_column :mshops, :liancate, :integer
  end

end

