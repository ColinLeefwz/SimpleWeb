class CreateLanguages < ActiveRecord::Migration
  def change
    create_table :languages do |t|
      t.string :long_version
      t.string :short_version

      t.timestamps
    end
  end
end
