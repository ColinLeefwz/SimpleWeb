class MembersController < ApplicationController
  load_and_authorize_resource except: [:profile]
  before_filter :set_member, only: [:profile]

  def dashboard
  end

  def profile
    @profile = @member.profile
  end

  def edit_profile
    @profile = @member.profile || @member.create_profile
    @from = 'edit_profile'

    respond_to do |format|
      format.js {render 'experts/update'}
    end
  end

  def update_profile
    respond_to do |format|
      format.js{
        @member.update_attributes(user_params)
        @member.profile.update_attributes(member_profile_params)

        render js: "window.location='#{profile_member_path(current_user)}'"
      }
    end
  end
  
  def refer_a_friend
    @email_message = current_user.build_refer_message(User::USER_TYPE[:member])
    @from = "experts/refer_a_user"
    respond_to do |format|
      format.js {render "update"}
    end
  end

  def experts
    @followed_experts = current_user.followed_users
    @from = "expert"
    respond_to do |format|
      format.js {render "update"}
    end
  end

  def contents
    @favorite_content = current_user.get_subscribed_sessions("ArticleSession")
    @from = "content"
    respond_to do |format|
      format.js {render "update"}
    end
  end

  def video_on_demand
    @favorite_session = current_user.get_subscribed_sessions( "VideoSession")
    @from = "video_on_demand"
    respond_to do |format|
      format.js {render "update"}
    end
  end

  private

  def set_member
    @member = Member.find params[:id]
  end

  def user_params
    params.require(:profile).permit(:first_name, :last_name, :avatar)
  end

  def member_profile_params
    params.require(:profile).permit(:title, :company, :location)
  end

end
