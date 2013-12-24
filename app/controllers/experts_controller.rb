class ExpertsController < ApplicationController
  load_and_authorize_resource except: [:profile]
  before_filter :set_expert, only: [:profile]

  def dashboard
    @sessions = @expert.sessions.order("draft desc")
  end

  def pending_page
    @from = 'pending_page'
    respond_to do |format|
      format.js { render 'update'}
    end
  end

  def refer_new_expert
    @email_message = current_user.build_refer_message(User::USER_TYPE[:expert])

    @from = "refer_a_user"
    respond_to do |format|
      format.js { render "update" }
    end
  end

  def profile
		video_interviews = VideoInterview.where(expert: @expert).order("updated_at desc").to_a
		announcements = Announcement.where(expert: @expert).order("updated_at desc").to_a
		articles = Session.where(expert: @expert).where(content_type: "ArticleSession").where(draft: false).order("always_show desc, updated_at desc").to_a
		@sessions = video_interviews.concat(announcements).concat(articles)
  end

  def edit_profile
    @profile = @expert.profile || @expert.create_profile
    @from = 'edit_profile'

    respond_to do |format|
      format.js {render 'experts/update'}
    end
  end

  def update_profile
    respond_to do |format|
      format.js{
        @expert.update_attributes(user_params)
        @expert.profile.update_attributes(expert_profile_params)

        render js: "window.location='#{profile_expert_path(current_user)}'"
      }
    end

  end

  def contents
    @sessions = current_user.contents
    @from = 'sessions/sessions'
    respond_to do |format|
      format.js { render 'experts/update'}
    end
  end

  def sessions
    @sessions = current_user.live_sessions
    @from = 'sessions/sessions'
    respond_to do |format|
      format.js { render 'experts/update'}
    end
  end

  def video_on_demand
    @videos = Resource.video.where(expert_id: current_user.id)
    @from = 'experts/video_on_demand'
    respond_to do |format|
      format.js { render 'experts/update' }
    end
  end

  private

  def set_expert
    @expert = Expert.find params[:id]
  end

  def session_params
    params.require(:session).permit(:title, :description, :cover, :video, {categories:[]}, :location, :price, :language, :start_date, :time_zone )
  end


  def expert_profile_params
    params.require(:profile).permit(:title, :company, :career, :education, :expertise, :location, :web_site)
  end

  def user_params
    params.require(:profile).permit(:first_name, :last_name, :avatar)
  end


end
