class AddDurationToSections < ActiveRecord::Migration
  def change
    add_column :sections, :duration, :string
  end
end
