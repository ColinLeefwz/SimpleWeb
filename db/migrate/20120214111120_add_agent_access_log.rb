class AddAgentAccessLog < ActiveRecord::Migration
  def self.up
	add_column :access_logs, :agent, :string, :length => 100
  end

  def self.down
	remove_column :access_logs, :agent
  end
end
