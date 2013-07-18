class CreateSessions < ActiveRecord::Migration
  def change
    create_table :sessions do |t|
      t.string :title
      t.text :description
      t.string :status
      t.string :location
      t.integer :expert_id

      t.timestamps
    end
  end
end
