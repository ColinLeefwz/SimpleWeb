require 'mandrill_api'

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

  protected
  def sign_up(resource_name, resource)
    super
    mandrill = MandrillApi.new
    mandrill.welcome_confirm(resource)
  end

end
