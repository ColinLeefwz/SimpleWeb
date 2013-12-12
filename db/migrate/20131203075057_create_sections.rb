class CreateSections < ActiveRecord::Migration
  def change
    create_table :sections do |t|
      t.text :description
      t.references :chapter, index: true
      t.integer :order

      t.timestamps
    end
  end
end
