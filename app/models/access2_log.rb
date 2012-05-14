class Access2Log < ActiveRecord::Base

	def self.table_name
		AccessLog.get_or_gen_table_name("access2")
	end

end
