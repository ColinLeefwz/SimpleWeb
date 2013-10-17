class ExpertsController < ApplicationController
  before_action :set_expert, only: [:dashboard, :show, :edit, :destroy, :update]

  def dashboard
    @sessions = @expert.sessions
  end

  private
    def set_expert
      @expert = Expert.find(params[:id])
    end

    def expert_params
      params.require(:expert).permit(:name, :avatar, :title, :company, :location, :expertise, :favorite_quote, :career, :education, :web_site, :article_reports, :speeches, :additional, :testimonials)
    end

end
