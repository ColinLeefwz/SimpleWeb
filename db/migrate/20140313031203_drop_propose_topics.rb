class DropProposeTopics < ActiveRecord::Migration
  def change
    drop_table :propose_topics
  end
end
