class ExpertsController < ApplicationController
  before_action :set_expert, only: [:show, :edit, :destroy, :update]

  # GET /experts
  # GET /experts.json
  def index
    @experts = Expert.where(authorized: true)
  end

  # GET /experts/1
  # GET /experts/1.json
  def show
  end

  # GET /experts/new
  def new
    @expert = Expert.new
  end

  # GET /experts/1/edit
  def edit
  end

  # POST /experts
  # POST /experts.json
  def create
    @expert = Expert.new(expert_params)

    if @expert.save
      redirect_to @expert, notice: 'Expert was successfully created.'
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /experts/1
  # PATCH/PUT /experts/1.json
  def update
    @expert.authorized = true
    @expert.save
    redirect_to @expert
  end

  # DELETE /experts/1
  # DELETE /experts/1.json
  def destroy
    @expert.destroy
    redirect_to experts_url
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_expert
      @expert = Expert.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def expert_params
      params.require(:expert).permit(:name, :title, :company, :location, :expertise, :favorite_quote, :career, :education, :web_site, :article_reports, :speeches, :additional, :testimonials)
    end

    # def check
    #   if session[:login] == nil
    #     logger.info("check is used")
    #     redirect_to sign_in_admin_index_path
    #   end
    #   # logger.info("session login" + session[:login].to_s)
    # end
end
