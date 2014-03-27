class CreateLandingitems < ActiveRecord::Migration
  def change
    create_table :landingitems do |t|
      t.references :landingable, index: true, polymorphic: true
      t.references :expert, index: true
      t.boolean :only_index

      t.timestamps
    end
  end
end
