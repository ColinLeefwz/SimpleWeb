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
		all_text = YAML.load_file(File.join(Rails.root, 'config', 'pending_text.yml'))
		text_params = params[:text]
		text_hash = all_text[text_params.to_s]
		@pending_text = [text_hash['title'], text_hash['content'], text_hash['footer']].join
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
		video_interviews = @expert.video_interviews.to_a
		courses = @expert.courses.to_a
		sessions = @expert.sessions.where(draft: false).to_a
    @items = video_interviews.concat(courses).concat(sessions)
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
    @items = current_user.contents
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
    params.require(:profile).permit(:title, :company, :country, :city, :twitter, :career, :education, :expertise, :location, :web_site)
  end

  def user_params
		params.require(:expert).permit(:first_name, :last_name, :time_zone, :avatar, intro_video_attributes: [:attached_video_hd_file_name, :attached_video_hd_content_type, :attached_video_hd_file_size, :attached_video_sd_file_name, :attached_video_sd_content_type, :attached_video_sd_file_size, :sd_url, :hd_url])
  end
end
