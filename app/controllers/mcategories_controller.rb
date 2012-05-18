class McategoriesController < ApplicationController
  before_filter :admin_authorize
  layout "admin"

  def index
   @mcategories =  Mcategory.paginate :all, :page => params[:page], :per_page => 20, :conditions => genCondition, :order => genOrder
  end

  def edit
    @mcategory = Mcategory.find_by_id(params[:id])
  end

  def update
    @mcategory = Mcategory.find_by_id(params[:id])

    if @mcategory.update_attributes(params[:mcategory])
      redirect_to :action => :show, :id => @mcategory
    else
      render :action => :edit
    end
  end

  def show
    @mcategory = Mcategory.find_by_id(params[:id])
  end


  def genCondition
    
  end

  def genOrder
    
  end
end
