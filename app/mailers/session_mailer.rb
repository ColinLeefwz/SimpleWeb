class SessionMailer < ActionMailer::Base
  default from: "no-replay@prodygia.com"

	def welcome_email(user)
		@user = user
		@url = 'http://localhost:3000/'

		mail(to: @user.email, subject: 'Welcome to Prodygia')
	end

	def enroll_session(user, session_id)
		email = user.email

		@session = Session.find session_id

		mail(to: email, subject: 'Enrolled Session Confirmation')

	end
end
