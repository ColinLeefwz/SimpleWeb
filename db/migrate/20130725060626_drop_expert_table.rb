class DropExpertTable < ActiveRecord::Migration
	def up
		drop_table :experts if self.table_exists?("experts")
	end

	def down
		raise ActiveRecord::IrreversibleMigration
	end
end
