class AddIntroableIdToIntroVideo < ActiveRecord::Migration
  def change
		add_column :intro_videos, :introable_id, :integer
		add_column :intro_videos, :introable_type, :string
  end
end
