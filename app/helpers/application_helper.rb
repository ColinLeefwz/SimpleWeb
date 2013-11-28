module ApplicationHelper
	def flash_class
		if flash[:alert]
			"alert-error"
		elsif flash[:error]
			"alert-something"
		elsif flash[:notice]
			"alert-success"
		end
	end

	def flash_message
		if flash[:alert]
			flash[:alert]
		elsif flash[:error]
			flash[:error]
		elsif flash[:notice]
			flash[:notice]
		end
		
	end
end
