class AddNumToLandingitem < ActiveRecord::Migration
  def change
    add_column :landingitems, :num, :integer
  end
end
