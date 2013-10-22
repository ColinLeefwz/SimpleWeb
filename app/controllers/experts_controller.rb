class ExpertsController < ApplicationController
  before_action :set_expert, only: [:dashboard, :new_post_content, :show, :edit, :destroy, :update]

  def dashboard
    authorize! :manage, :dashboard
    @sessions = @expert.sessions
  end

  def new_post_content
    @article_session = ArticleSession.new
  end

  def create_post_content
    @article_session = ArticleSession.new(article_params)
    @article_session.expert = current_user

    if @article_session.save
      redirect_to dashboard_expert_path(current_user), notice: 'successful'
    else
      redirect_to dashboard_expert_path(current_user), notice: 'failed'
    end
  end

  def refer_new_expert
    @expert = current_user

    @invited_expert = Expert.new

    @email_message = EmailMessage.new(sender: current_user, subject: "Invite you to be expert at Prodygia", message: "good day", from_name: "#{current_user.first_name} #{current_user.last_name}", from_address: "no-reply@prodygia", reply_to: "#{current_user.email}")
  end

  private
    def set_expert
      @expert = Expert.find(params[:id])
    end

    def article_params
      params.require(:article_session).permit(:title, :description, :cover, {categories:[]} )
    end

    def expert_params
      params.require(:expert).permit(:name, :avatar, :title, :company, :location, :expertise, :favorite_quote, :career, :education, :web_site, :article_reports, :speeches, :additional, :testimonials)
    end

end
