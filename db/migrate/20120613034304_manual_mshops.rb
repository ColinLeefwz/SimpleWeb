class ManualMshops < ActiveRecord::Migration
  def up
    add_column :mshops, :manual, :boolean, :default => false
  end

  def down
    remove_column :mshops, :manual
  end
end
