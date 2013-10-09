class SessionMailer < ActionMailer::Base
  default from: "no-reply@prodygia.com"

	def welcome_email(user)
		@user = user
		@url = 'http://localhost:3000/'

		mail(to: @user.email, subject: 'Welcome to Prodygia')
	end

	def enroll_session(user, session_id)
		@session = Session.find session_id
		# mail(to: email, subject: 'Enrolled Session Confirmation')
		mail(to: user.email, subject: 'Enrolled Session Confirmation')
    headers['X-MC-Template'] = "sameer_test_1"
    headers['X-MC-MergeVars'] = { "firstname": user.first_name }.to_json

	end
end
