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
    self.resource.provider = "prodygia"
  end

  def edit
    @from = "users/registrations/settings"
    respond_to do |format|
      format.js {render "members/update"}
      format.html {render "edit"}
    end
  end

  protected
  def sign_up(resource_name, resource)
    super
    mandrill = MandrillApi.new
    mandrill.welcome_confirm(resource)
  end

end
