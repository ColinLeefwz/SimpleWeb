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

    if @propose_topic.save
      redirect_to @propose_topic, notice: 'Propose topic was successfully created.'
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /propose_topics/1
  # PATCH/PUT /propose_topics/1.json
  def update
    if @propose_topic.update(propose_topic_params)
      redirect_to @propose_topic, notice: 'Propose topic was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE /propose_topics/1
  # DELETE /propose_topics/1.json
  def destroy
    @propose_topic.destroy
    redirect_to propose_topics_url
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
