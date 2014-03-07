class RemoveTempPathFromVideos < ActiveRecord::Migration
  def up
    remove_column :videos, :SD_temp_path
    remove_column :videos, :HD_temp_path
  end

  def down
    add_column :videos, :SD_temp_path, :string
    add_column :videos, :HD_temp_path, :string
  end
end
