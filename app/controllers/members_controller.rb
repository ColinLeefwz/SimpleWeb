class MembersController < ApplicationController
  def dashboard
    @member = Member.where(id: params[:id]).first
  end

  def refer_a_friend
    @member = current_user
    @email_message = current_user.build_refer_message
    @from = "refer_a_friend"
    respond_to do |format|
      format.js {render "update"}
    end
  end
end
