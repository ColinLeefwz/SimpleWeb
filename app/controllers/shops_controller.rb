class ShopsController < ApplicationController
  before_filter :admin_authorize
  layout "admin"

  def index
    @shops = Mshop.paginate :all, :page => params[:page], :per_page => 20, :conditions => genCondition, :order => genOrder
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @shops }
      format.js
    end
  end

  def new
    @shop = Mshop.new
  end

  def create
    @shop = Mshop.new(params[:shop])
    if @shop.save
      redirect_to :action => :show, :id => @shop
    else
      render :template => "shops/new.html"
    end
  end

  def edit
    @shop = Mshop.find_by_id(params[:id])
  end

  def update
    @shop = Mshop.find_by_id(params[:id])
    if @shop.update_attributes(params[:shop])
       redirect_to :action => :show, :id => @shop
    else
      render :action => :edit
    end
  end

  def show
    @shop = Mshop.find_by_id(params[:id])
  end

  def destory
    
  end




  private

  def genCondition
    s = ""
    ad = ""
    h = Hash.new
    if has_value params[:id]
      s << ad
      s << "id = :id"
      h[:id] = "#{params[:id]}"
      ad = " and"
    end
    if has_value params[:phone]
      s << ad
      s << " phone like :phone"
      h[:phone] = "%#{params[:phone]}%"
      ad = " and"
    end
    if has_value params[:name]
      s << ad
      s << " name like :name"
      h[:name] = "%#{params[:name]}%"
      ad = " and"
    end
    if has_value params[:linkman]
      s << ad
      s << " linkman like :linkman "
      h[:linkman] = "%#{params[:linkman]}%"
      ad = " and"
    end
   
    if has_value params[:created_at]
      s << ad
      s << " created_at >= :created_at"
      h[:created_at] = "#{params[:created_at]}"
      ad = " and"
    end
    [s, h]
  end

  def genOrder
    
  end
end
