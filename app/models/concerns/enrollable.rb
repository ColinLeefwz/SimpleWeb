module Enrollable
  extend ActiveSupport::Concern

	def enroll_session(session)
		self.enrolled_sessions << session
	end
end
