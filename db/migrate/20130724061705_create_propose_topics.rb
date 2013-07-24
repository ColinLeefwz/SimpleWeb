class CreateProposeTopics < ActiveRecord::Migration
  def change
    create_table :propose_topics do |t|
      t.string :Name
      t.string :Location
      t.string :Email
      t.text :Topic

      t.timestamps
    end
  end
end
