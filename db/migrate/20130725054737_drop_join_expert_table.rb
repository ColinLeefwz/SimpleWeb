class DropJoinExpertTable < ActiveRecord::Migration
	def up
		drop_table :join_experts if self.table_exists?("join_experts")
	end

	def down
		raise ActiveRecord::IrreversibleMigration
	end
end
