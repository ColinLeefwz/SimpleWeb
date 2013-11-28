class RenameExpertProfileTable < ActiveRecord::Migration
  def change
    rename_table :expert_profiles, :profiles
  end
end
