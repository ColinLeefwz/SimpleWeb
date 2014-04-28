class ExpertsController < ApplicationController
  load_and_authorize_resource except: [:profile, :load_more]
  before_action :set_expert, only: [:profile, :load_more]

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
    # Peter at 2014-04-07: comment them, after we fix the overlap bug
    # cookies[:profile_batch_point] = 0
    # cookies[:no_more_load] = false
    # cookies[:expert_token] = @expert.user_name
    # @items = @expert.load_landingitems(0)
    # increase_cookie

    @items = @expert.all_profile_items
    @profile = @expert.profile
    # video_interviews = @expert.video_interviews
    # courses = @expert.courses
    # articles = @expert.articles.where(draft: false)
    # @items = video_interviews + courses + articles
    # @profile = @expert.profile
  end

  def load_more
    point = cookies[:profile_batch_point].to_i
    @items = @expert.load_landingitems(point)
    respond_to do |format|
      if @expert.load_landingitems(point + 1).empty?
        cookies[:no_more_load] = true
      else
        cookies[:no_more_load] = false
      end
      increase_cookie
      format.js { render "welcome/load_more" }
    end


  end

  def edit_profile
    @profile = @expert.profile
    respond_to do |format|
      format.js{
        render partial: 'dashboard/profile/edit'
      }
    end
  end

  def update_profile
    respond_to do |format|
      format.js{
        @expert.update_attributes(expert_params)
        @expert.profile.update_attributes(expert_profile_params)
        flash[:success] = "successfully update your profile"
        render js: "window.location='#{dashboard_expert_path(current_user.reload)}'"
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
  def increase_cookie
    new_val = cookies[:profile_batch_point].to_i + 1
    cookies[:profile_batch_point] = new_val
  end

  def get_pending_text(type)
    all_text = YAML.load_file(File.join(Rails.root, 'config', 'pending_text.yml'))
    text_hash = all_text[type]
    @pending_text = [text_hash['title'], text_hash['content'], text_hash['footer']].join
  end

  def set_expert
    @expert = Expert.find(params[:id])
  end

  def expert_profile_params
    params.require(:profile).permit(:title, :company, :country, :city, :twitter, :career, :education, :expertise, :location, :web_site)
  end

  def expert_params
    params.require(:expert).permit(:first_name, :last_name, :user_name, :time_zone, :avatar, :subscribe_newsletter, Video::Attributes)
  end
end
