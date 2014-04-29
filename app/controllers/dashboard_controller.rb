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
    # Peter todo:
    # authorize article for current_user
    # member can not post new article
    respond_to do |format|
      format.js {}
      format.html {}
    end
  end

  private
  def set_profile
    @profile = current_user.profile
  end
end
