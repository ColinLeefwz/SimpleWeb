class ShopsController < ApplicationController
  before_filter :admin_authorize
  layout "admin"

  def index
    @shops = Mshop.paginate :page => params[:page], :per_page => 20, :conditions => genCondition, :order => genOrder
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @shops }
      format.js
    end
  end

  def manual
    Mshop.find_all_by_id(params[:manuals]).each{|m| m.update_attribute(:manual, true)}
    Mshop.find_all_by_id(params[:all] - params[:manuals]).each{|m| m.update_attribute(:manual, false)}
    redirect_to request.env["HTTP_REFERER"]
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

  def check
     @shops = Mshop.paginate :page => params[:page], :per_page => 20, :conditions => genCondition, :order => genOrder
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
    ["id DESC", "id ASC", "comment_count DESC", "comment_count ASC"][params[:order_by].to_i]
  end
end
