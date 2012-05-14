class AddPidAccessLog < ActiveRecord::Migration
  def self.up
	add_column :access_logs, :pid, :integer
  end

  def self.down
	add_column :access_logs, :pid
  end
end
