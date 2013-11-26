class MembersController < ApplicationController
  load_and_authorize_resource 
  def dashboard
    @member = Member.where(id: params[:id]).first
  end

  def refer_a_friend
    @member = current_user
    @email_message = current_user.build_refer_message(User::USER_TYPE[:member])
    @from = "experts/refer_a_user"
    respond_to do |format|
      format.js {render "update"}
    end
  end
end
