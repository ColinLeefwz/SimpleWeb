class CreateResources < ActiveRecord::Migration
  def change
    create_table :resources do |t|
      t.integer :expert_id
      t.string :attached_file_file_path
      t.string :direct_upload_url
      t.attachment :attached_file
      t.timestamps
    end
  end
end
