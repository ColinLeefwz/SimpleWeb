class ChangeVideoColumnName < ActiveRecord::Migration
  def change
    rename_column :videos, :SD_file_path, :SD_temp_path
    rename_column :videos, :HD_file_path, :HD_temp_path

    add_column :videos, :SD_current_path, :string
    add_column :videos, :HD_current_path, :string
  end
end
