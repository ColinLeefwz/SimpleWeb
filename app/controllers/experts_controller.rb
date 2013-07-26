class ExpertsController < ApplicationController
  before_action :set_expert, only: [:show, :edit, :update, :destroy]

  # GET /experts
  # GET /experts.json
  def index
    @experts = Expert.all
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

    respond_to do |format|
      if @expert.save
        format.html { redirect_to @expert, notice: 'Expert was successfully created.' }
        format.json { render action: 'show', status: :created, location: @expert }
      else
        format.html { render action: 'new' }
        format.json { render json: @expert.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /experts/1
  # PATCH/PUT /experts/1.json
  def update
    respond_to do |format|
      if @expert.update(expert_params)
        format.html { redirect_to @expert, notice: 'Expert was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @expert.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /experts/1
  # DELETE /experts/1.json
  def destroy
    @expert.destroy
    respond_to do |format|
      format.html { redirect_to experts_url }
      format.json { head :no_content }
    end
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
