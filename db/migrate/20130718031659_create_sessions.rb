class CreateSessions < ActiveRecord::Migration
  def change
    create_table :sessions do |t|
      t.string :title
      t.references :expert, index: true
      t.text :description
      t.string :status

      t.timestamps
    end
  end
end
