class MembersController < ApplicationController
  load_and_authorize_resource 
  def dashboard
    @member = Member.where(id: params[:id]).first
  end
end
