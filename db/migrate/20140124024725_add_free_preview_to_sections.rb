class AddFreePreviewToSections < ActiveRecord::Migration
  def change
    add_column :sections, :free_preview, :boolean, default: false
  end
end
