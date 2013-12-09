class CreateVideoInterviews < ActiveRecord::Migration
  def change
    create_table :video_interviews do |t|
			t.string :title
			t.references :expert, index: true
			t.string :categories, array: true, default: '{}'
			t.text :description

			t.attachment :attached_video

      t.timestamps
    end

		add_index :video_interviews, :categories, using: 'gin'
  end
end
