class ExpertsController < ApplicationController
  load_and_authorize_resource except: [:profile]
  before_filter :set_expert, only: [:profile]

  def activity_stream
    @from = 'activity_stream'
    respond_to do |format|
      format.js {render 'update'}
    end
  end

  def dashboard
    @profile = @expert.profile || @expert.create_profile
  end

  def pending_page
    @from = 'pending_page'
    respond_to do |format|
      format.js { render 'update'}
    end
  end

  def refer_new_expert
    @email_message = current_user.build_refer_message(User::USER_TYPE[:expert])

    @from = "refer_expert"
    respond_to do |format|
      format.js { render "update" }
    end
  end

  def profile
    @items = @expert.sessions.to_a.concat(@expert.video_interviews.to_a).concat(@expert.courses.to_a)
    @profile = @expert.profile || @expert.create_profile
  end

  def edit_profile
    @profile = @expert.profile || @expert.create_profile
		@intro_video = @expert.intro_video || @expert.create_intro_video
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
    @show_shares = true
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
    params.require(:profile).permit(:title, :company, :twitter, :career, :education, :expertise, :location, :web_site)
  end

  def user_params
		params.require(:expert).permit(:first_name, :last_name, :avatar, intro_video_attributes: [:attached_video_hd_file_name, :attached_video_hd_content_type, :attached_video_hd_file_size, :attached_video_sd_file_name, :attached_video_sd_content_type, :attached_video_sd_file_size, :sd_url, :hd_url])
  end
end
