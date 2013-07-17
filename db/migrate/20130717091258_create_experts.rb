class CreateExperts < ActiveRecord::Migration
  def change
    create_table :experts do |t|
      t.string :name
      t.string :image_url
      t.string :company
      t.string :title

      t.timestamps
    end
  end
end
