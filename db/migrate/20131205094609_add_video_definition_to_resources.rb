class AddVideoDefinitionToResources < ActiveRecord::Migration
  def change
    add_column :resources, :video_definition, :string
  end
end
