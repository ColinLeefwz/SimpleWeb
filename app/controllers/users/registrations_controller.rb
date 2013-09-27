class Users::RegistrationsController < Devise::RegistrationsController
	def new
		super
	end

	def create
		super
	end

	def update
		super
	end

	def build_resource(hash=nil)
		self.resource = Member.new_with_session(hash || {}, session)
	end
end
