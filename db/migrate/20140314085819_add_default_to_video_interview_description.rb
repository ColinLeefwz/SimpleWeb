class AddDefaultToVideoInterviewDescription < ActiveRecord::Migration
  def change
    change_column :video_interviews, :description, :text, default: "  "
  end
end
