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

end
