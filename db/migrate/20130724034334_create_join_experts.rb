class CreateJoinExperts < ActiveRecord::Migration
  def change
    create_table :join_experts do |t|
      t.string :Name
      t.string :Location
      t.string :Email
      t.text :Expertise

      t.timestamps
    end
  end
end
