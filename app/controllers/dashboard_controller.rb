class DashboardController < ApplicationController
  before_action :set_profile

  def dashboard
  end

  def activity_stream
    stream = ActivityStream.find(current_user.id)
    @activities = stream.activities
    respond_to do |format|
      format.js
      format.html
    end
  end

  def settings
    respond_to do |format|
      format.js
      format.html
    end
  end

  def edit_profile
    respond_to do |format|
      format.js{
        render partial: 'dashboard/profile/edit'
      }
      format.html
    end
  end

  def post_new_article
    @article = Article.new
    authorize! :create, Article
    respond_to do |format|
      format.js
      format.html
    end
  end

  def content
    authorize! :create, Article ## member can not access this action
    @items = current_user.contents

    respond_to do |format|
      @show_shares = true
      format.js {
        render partial: 'shared/cards' , locals: { items: @items }
      }

      format.html
    end
  end

  def produced_courses
    authorize! :create, Article ## member can not access this action
    @courses = current_user.courses

    respond_to do |format|
      format.js {
        if @courses.empty?
          get_pending_text("video_courses")
          @from = 'pending_page'
          render 'experts/update'
        else
          render partial: 'shared/cards', locals: {items: @courses}
        end
      }

      format.html {
        if @courses.empty?
          get_pending_text("video_courses")
          @empty = true
        else
          @empty = false
        end
      }
    end
  end

  def subscribed_courses
    @enrolled_courses = current_user.enrolled_courses
    if @enrolled_courses.empty?
      @enrolled_courses = Course.recommend_courses(current_user)
      @recommendation = true
    end
    respond_to do |format|
      format.js
      format.html
    end
  end

  def favorite_experts
    @followed_experts = current_user.followed_users
    if @followed_experts.empty?
      @followed_experts = Expert.where("id != ?", current_user.id).order("RANDOM()").limit(3)
      @recommendation = true
    end
    respond_to do |format|
      format.js
      format.html
    end
  end

  def favorite_content
    @favorite_contents = current_user.subscribed_contents
    if @favorite_contents.empty?
      if current_user.is_a? Expert
        @favorite_contents = Article.where.not(draft: true, expert: current_user).order("RANDOM()").limit(3)
      elsif current_user.is_a? Member
        @favorite_contents = Article.where.not(draft: true, expert: Expert.staff).order("RANDOM()").limit(3)
      end
      @recommendation = true
    end
    respond_to do |format|
      format.js
      format.html
    end
  end

  def favorite_courses
    @subscribed_courses = current_user.subscribed_courses
    if @subscribed_courses.empty?
      @subscribed_courses = Course.recommend_courses(current_user)
      @recommendation = true
    end
    respond_to do |format|
      format.js
      format.html
    end
  end

  private
  def set_profile
    @profile = current_user.profile
  end

  def get_pending_text(type)
    all_text = YAML.load_file(File.join(Rails.root, 'config', 'pending_text.yml'))
    text_hash = all_text[type]
    @pending_text = [text_hash['title'], text_hash['content'], text_hash['footer']].join
  end
end
