class McitiesController < ApplicationController
  before_filter :admin_authorize
  layout "admin"
  def index
    @mcities = Mcity.paginate :page => params[:page], :per_page => 20, :conditions => genCondition, :order => genOrder
  end

  def new
    @mcity = Mcity.new
  end

  def create
    @mcity = Mcity.new(params[:mcity])
    if @mcity.save
      redirect_to :action => :show, :id => @mcity
    else
      render :action => "new"
    end
  end

  def edit
    @mcity = Mcity.find_by_id(params[:id])
  end

  def update
    @mcity = Mcity.find_by_id(params[:id])
    if @mcity.update_attributes(params[:mcity])
       redirect_to :action => :show, :id => @mcity
    else
      render :action => :edit
    end
  end

  def show
    @mcity = Mcity.find_by_id(params[:id])
  end

  def destory
    
  end


  private

  def genCondition


  end

  def genOrder
    
  end
end
