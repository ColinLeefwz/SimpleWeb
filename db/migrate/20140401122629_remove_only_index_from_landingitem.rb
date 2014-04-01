class RemoveOnlyIndexFromLandingitem < ActiveRecord::Migration
  def change
    remove_column :landingitems, :only_index
  end
end
