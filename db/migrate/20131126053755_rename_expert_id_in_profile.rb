class RenameExpertIdInProfile < ActiveRecord::Migration
  def change
    rename_column :profiles, :expert_id, :user_id
  end
end
