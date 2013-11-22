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
    @expert = current_user
    @email_message = current_user.build_refer_message

    @from = "refer_new_expert"
    respond_to do |format|
      format.js { render "update" }
    end
  end

  def profile
    @sessions = @expert.sessions
  end

  def edit_profile
    @profile = @expert.expert_profile
    @from = 'edit_profile'

    respond_to do |format|
      format.js {render 'experts/update'}
    end
  end

  def update_profile
    respond_to do |format|
      format.js{
        @expert.update_attributes(user_params)
        @expert.expert_profile.update_attributes(profile_params)
        @from = 'profile'

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

  private

  def set_expert
    @expert = Expert.find params[:id]
  end

  def session_params
    params.require(:session).permit(:title, :description, :cover, :video, {categories:[]}, :location, :price, :language, :start_date, :time_zone )
  end

  def expert_params
    params.require(:expert).permit(:name, :avatar, :title, :company, :location, :expertise, :favorite_quote, :career, :education, :web_site, :article_reports, :speeches, :additional, :testimonials)
  end

  def profile_params
    params.require(:expert_profile).permit(:tilte, :company, :career, :education, :expertise)
  end
  def user_params
    params.require(:expert_profile).permit(:first_name, :last_name, :avatar)
  end


end
