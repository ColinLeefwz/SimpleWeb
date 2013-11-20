class MembersController < UsersController
  def dashboard
    @member = Member.where(id: params[:id]).first
  end
end
