class CreateCategorization < ActiveRecord::Migration
  def change
    create_table :categorizations do |t|
      t.integer :category_id
      t.string :categoriable_type
      t.integer :categoriable_id
    end
  end
end
