class MembersController < ApplicationController
  load_and_authorize_resource except: [:profile]
  before_filter :set_member, only: [:profile]

  def dashboard
    @profile = @member.profile || @member.create_profile
  end

  def activity_stream
    @from = "activity_stream"
    respond_to do |format|
      format.js {render 'experts/update'}
    end
  end

  def profile
    @profile = @member.profile
  end

  ## Peter at 2014-04-29: this method and the one in ExpertsController can be merged together
  # into UsersController
  def update_profile
    respond_to do |format|
      format.js{
        @member.update_attributes(user_params)
        @member.profile.update_attributes(member_profile_params)
        flash[:success] = "successfully update your profile"
        render js: "window.location='#{dashboard_path}'"
      }
    end
  end

  private
  def set_member
    @member = Member.find params[:id]
  end

  def user_params
    params.require(:profile).permit(:first_name, :last_name, :user_name, :email, :avatar, :time_zone, :subscribe_newsletter)
  end

  def member_profile_params
    params.require(:profile).permit(:title, :company, :location, :country, :city)
  end

end
