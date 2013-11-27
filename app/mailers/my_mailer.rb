require 'mandrill_api'

class MyMailer < Devise::Mailer
	helper :application

	def reset_password_instructions(record, token, opts=[])
		token = record.reset_password_token
		reset_link = edit_user_password_url(record, reset_password_token: token)
		mandrill = MandrillApi.new
		mandrill.reset_password(record, reset_link)
	end

end
