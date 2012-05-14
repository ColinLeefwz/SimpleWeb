class AddRefererAccessLog < ActiveRecord::Migration
  def self.up
	add_column :access_logs, :referer, :string, :length => 64
  end

  def self.down
	remove_column :access_logs, :referer
  end
end
