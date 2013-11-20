class MembersController < ApplicationController
  def dashboard
    @member = Member.where(id: params[:id]).first
  end
end
