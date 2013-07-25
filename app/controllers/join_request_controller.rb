class JoinRequestController < ApplicationController
  def index
    @joins = Expert.where(authorized: false)
  end

  def show
  end

  def destroy
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
