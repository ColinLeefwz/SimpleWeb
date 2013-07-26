class ProposeTopicsController < ApplicationController
  before_action :set_propose_topic, only: [:show, :edit, :update, :destroy]

  # GET /propose_topics
  # GET /propose_topics.json
  def index
    @propose_topics = ProposeTopic.all
  end

  # GET /propose_topics/1
  # GET /propose_topics/1.json
  def show
  end

  # GET /propose_topics/new
  def new
    @propose_topic = ProposeTopic.new
  end

  # GET /propose_topics/1/edit
  def edit
  end

  # POST /propose_topics
  # POST /propose_topics.json
  def create
    @propose_topic = ProposeTopic.new(propose_topic_params)

    respond_to do |format|
      if @propose_topic.save
        format.html { redirect_to @propose_topic, notice: 'Propose topic was successfully created.' }
        format.json { render action: 'show', status: :created, location: @propose_topic }
      else
        format.html { render action: 'new' }
        format.json { render json: @propose_topic.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /propose_topics/1
  # PATCH/PUT /propose_topics/1.json
  def update
    respond_to do |format|
      if @propose_topic.update(propose_topic_params)
        format.html { redirect_to @propose_topic, notice: 'Propose topic was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @propose_topic.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /propose_topics/1
  # DELETE /propose_topics/1.json
  def destroy
    @propose_topic.destroy
    respond_to do |format|
      format.html { redirect_to propose_topics_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_propose_topic
      @propose_topic = ProposeTopic.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def propose_topic_params
      params.require(:propose_topic).permit(:Name, :Location, :Email, :Topic)
    end
end
