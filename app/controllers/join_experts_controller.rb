class JoinExpertsController < ApplicationController
  before_action :set_join_expert, only: [:show, :edit, :update, :destroy]

  # GET /join_experts
  # GET /join_experts.json
  def index
    @join_experts = JoinExpert.all
  end

  # GET /join_experts/1
  # GET /join_experts/1.json
  def show
  end

  # GET /join_experts/new
  def new
    @join_expert = JoinExpert.new
  end

  # GET /join_experts/1/edit
  def edit
  end

  # POST /join_experts
  # POST /join_experts.json
  def create
    @join_expert = JoinExpert.new(join_expert_params)

    respond_to do |format|
      if @join_expert.save
        format.html { redirect_to @join_expert, notice: 'Join expert was successfully created.' }
        format.json { render action: 'show', status: :created, location: @join_expert }
      else
        format.html { render action: 'new' }
        format.json { render json: @join_expert.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /join_experts/1
  # PATCH/PUT /join_experts/1.json
  def update
    respond_to do |format|
      if @join_expert.update(join_expert_params)
        format.html { redirect_to @join_expert, notice: 'Join expert was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @join_expert.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /join_experts/1
  # DELETE /join_experts/1.json
  def destroy
    @join_expert.destroy
    respond_to do |format|
      format.html { redirect_to join_experts_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_join_expert
      @join_expert = JoinExpert.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def join_expert_params
      params.require(:join_expert).permit(:Name, :Location, :Email, :Expertise)
    end
end
