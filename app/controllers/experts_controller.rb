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

  def validate_invite_email
    to_address = params[:to_address]

    expert = User.find_by email: to_address

    error_message = ""
    flag = true

    if to_address.empty?
      error_message = "Email address can not be blank"
      flag = false
    elsif expert
      error_message = "This expert has already been invited to Prodygia"
      flag = false
    end

    if flag
      render json: {status: true}
    else
      render json: { error_message: error_message, status: false }
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
