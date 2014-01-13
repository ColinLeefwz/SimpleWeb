class CreateVisits< ActiveRecord::Migration
  def change
    create_table :visits do |t|
      t.integer :visitable_id
      t.string :visitable_type
      t.integer :page_views
    end

    add_index :visits, [:visitable_id, :visitable_type]
  end
end
