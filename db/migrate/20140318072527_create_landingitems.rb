class CreateLandingitems < ActiveRecord::Migration
  def change
    create_table :landingitems do |t|
      t.references :landingable, index: true, polymorphic: true

      t.timestamps
    end
  end
end
