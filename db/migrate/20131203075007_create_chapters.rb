class CreateChapters < ActiveRecord::Migration
  def change
    create_table :chapters do |t|
      t.text :description
      t.references :course, index: true
      t.integer :order

      t.timestamps
    end
  end
end
