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
    @profile = @expert.profile
  end

  def pending_page
    get_pending_text(params[:text].to_s)
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
    video_interviews = @expert.video_interviews
    courses = @expert.courses
    articles = @expert.articles.where(draft: false)
    @items = video_interviews + courses + articles
    @profile = @expert.profile
  end

  def edit_profile
    @profile = @expert.profile
    @video = @expert.video
    @from = 'edit_profile'

    respond_to do |format|
      format.js {render 'experts/update'}
    end
  end

  def update_profile
    respond_to do |format|
      format.js{
        @expert.update_attributes(expert_params)
        @expert.profile.update_attributes(expert_profile_params)
        flash[:success] = "successfully update your profile"
        render js: "window.location='#{dashboard_expert_path(current_user)}'"
      }
    end

  end

  def consultations
    @consultations = @expert.received_consultations.where(status: [Consultation::STATUS[:processed], Consultation::STATUS[:accepted]])
    respond_to do |format|
      @from = "consultations/items"
      format.js { render "experts/update" }
    end
  end

  def contents
    @items = current_user.contents

    respond_to do |format|
      format.js {
        @show_shares = true
        render partial: 'shared/cards', locals: { items: @items }
      }
    end
  end

  def video_courses
    courses = current_user.courses

    #todo:  we can split the role of experts/update into something like shared/(dashboard)/cards, shared/(dashboard)/static, so that we don't need to pass instant variable into experts/update
    respond_to do |format|
      format.js {
        if courses.empty?
          get_pending_text("video_courses")
          @from = 'pending_page'
          render 'experts/update'
        else
          render partial: 'shared/cards', locals: {items: courses}
        end
      }
    end
  end

  private
  def get_pending_text(type)
    all_text = YAML.load_file(File.join(Rails.root, 'config', 'pending_text.yml'))
    text_hash = all_text[type]
    @pending_text = [text_hash['title'], text_hash['content'], text_hash['footer']].join
  end

  def set_expert
    @expert = Expert.find params[:id]
  end

  def expert_profile_params
    params.require(:profile).permit(:title, :company, :country, :city, :twitter, :career, :education, :expertise, :location, :web_site)
  end

  def expert_params
    params.require(:expert).permit(:first_name, :last_name, :time_zone, :avatar, :subscribed, Video::Attributes)
  end
end
