class CreateAnnouncements < ActiveRecord::Migration
  def change
    create_table :announcements do |t|
      t.string :title
      t.text :description
      t.string :sd_url
      t.string :hd_url
      t.string :language
      t.boolean :draft
      t.boolean :canceled
			t.string :categories, array: true, default: '{}'
			t.references :expert, index: true

			t.attachment :attached_video_hd
			t.attachment :attached_video_sd

      t.timestamps
    end
		add_index :announcements, :categories, using: 'gin'
		add_attachment :announcements, :cover
  end
end
