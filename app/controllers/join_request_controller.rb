class JoinRequestController < ApplicationController
  def index
    @joins = Expert.where(authorized: false)
  end

  def show
  end

  def destroy
    id = params[:id]
    @expert = Expert.find(id)
    @expert.destroy

    redirect_to  join_request_index_url, notice: "Rejected"
    
    #TODO: email function
  end

  def new
  end

  def edit
  end

  def create
  end

  def update
  end
end
