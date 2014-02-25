class AddFilePathToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :SD_file_path, :string
    add_column :videos, :HD_file_path, :string
  end
end
