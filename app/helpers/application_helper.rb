module ApplicationHelper
	def flash_class
		if flash[:alert]
			"alert-error"
		elsif flash[:error]
			"alert-something"
		end
	end

	def flash_message
		if flash[:alert]
			flash[:alert]
		elsif flash[:error]
			flash[:error]
		end
		
	end
end
