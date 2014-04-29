class DashboardController < ApplicationController
  before_action :set_profile

  def dashboard
  end

  def settings
    respond_to do |format|
      format.js {}
      format.html {}
    end
  end

  def edit_profile
    respond_to do |format|
      format.js{
        render partial: 'dashboard/profile/edit'
      }
      format.html {}
    end
  end

  def post_new_article
    @article = Article.new
    authorize! :create, Article
    respond_to do |format|
      format.js {}
      format.html {}
    end
  end

  def contents
    authorize! :create, Article ## member can not access this action
    @items = current_user.contents

    respond_to do |format|
      @show_shares = true
      format.js {
        render partial: 'shared/cards' , locals: { items: @items }
      }

      format.html { }
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
