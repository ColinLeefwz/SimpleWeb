class AddSectionIdToResources < ActiveRecord::Migration
  def change
    add_reference :resources, :section, index: true
  end
end
