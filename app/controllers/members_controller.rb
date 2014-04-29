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

  def experts
    @followed_experts = current_user.followed_users
    if @followed_experts.empty?
      @followed_experts = Expert.where("id != ?", current_user.id).order("RANDOM()").limit(3)
      @recommendation = true
    end
    @from = "expert"
    respond_to do |format|
      format.js {render "update"}
    end
  end

  # gecko: we should duck type that
  def contents
    @favorite_contents = current_user.subscribed_contents
    if @favorite_contents.empty?
      if current_user.is_a? Expert
        @favorite_contents = Article.where.not(draft: true, expert: current_user).order("RANDOM()").limit(3)
      elsif current_user.is_a? Member
        @favorite_contents = Article.where.not(draft: true, expert: Expert.staff).order("RANDOM()").limit(3)
      end
      @recommendation = true
    end
    @from = "content"
    respond_to do |format|
      format.js {render "update"}
    end
  end

  def video_on_demand
    @subscribed_courses = current_user.subscribed_courses
    if @subscribed_courses.empty?
      @subscribed_courses = Course.recommend_courses(current_user)
      @recommendation = true
    end
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
    params.require(:profile).permit(:first_name, :last_name, :user_name, :email, :avatar, :time_zone, :subscribe_newsletter)
  end

  def member_profile_params
    params.require(:profile).permit(:title, :company, :location, :country, :city)
  end

end
