class DropJoinExpertTable < ActiveRecord::Migration
	def up
		drop_table :join_experts
	end

	def down
		raise ActiveRecord::IrreversibleMigration
	end
end
