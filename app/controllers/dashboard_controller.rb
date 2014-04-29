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
    @items = current_user.contents

    respond_to do |format|
      @show_shares = true
      format.js {
        render partial: 'shared/cards' , locals: { items: @items }
      }

      format.html { }
    end
  end

  private
  def set_profile
    @profile = current_user.profile
  end
end
