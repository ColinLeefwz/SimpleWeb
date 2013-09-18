# coding: utf-8

class Shop3LinesController < ApplicationController
  before_filter :shop_authorize
  before_filter :master_authorize, :only => [ :edit, :del, :update]
  layout 'shop3'
  include Paginate

  def index
    hash = {admin_sid: session[:shop_id]}
    sort ={_id: -1}
    @lines = paginate("Line", params[:page], hash, sort,10)
  end

  def edit
    @line_partner = @line.shop_line_partner
    ids = session_shop.partners.map{|m| m[0]}
    @partners = Shop.where2({_id: {"$in" => ids}})
  end

  def new
    ids = session_shop.partners.map{|m| m[0]}
    @partners = Shop.where2({_id: {"$in" => ids}})
  end

  def create
    @line = Line.new
    @line.admin_sid = session[:shop_id]
    @line.name = params[:name]
    arr=[]
    params[:arr][:time].each do |t|
      shop = Shop.find_by_id(params[:arr][:id].shift)
      time2= params[:arr][:time2].shift
      arr << {:time => t,:time2 => time2, :sid => shop.id, :lo => shop.lo } if shop
    end
    @line.arr = arr
    @line.save
    if params[:partners]
      shop_line_partner = ShopLinePartner.new
      shop_line_partner.id = @line.reload.id
      shop_line_partner.partners = params[:partners]
      shop_line_partner.save
    end
    redirect_to :action => "show", :id => @line.id
  end

  def show
    @line = Line.find_primary(params[:id])
    render :text => "该路线图不是您的，你无权操作！" if @line.admin_sid.to_i != session[:shop_id].to_i
  end

  def update
    @line.name = params[:name]
    arr=[]
    params[:arr][:time].each do |t|
      shop = Shop.find_by_id(params[:arr][:id].shift)
      time2= params[:arr][:time2].shift
      arr << {:time => t,:time2 => time2, :sid => shop.id, :lo => shop.lo } if shop
    end
    @line.arr = arr
    @line.save
    if params[:partners]
      shop_line_partner = ShopLinePartner.find_or_new(@line.reload.id)
      shop_line_partner.partners = params[:partners]
      shop_line_partner.save
    else
      @line.shop_line_partner.try(:delete)
      Rails.cache.delete("ShopLinePartner#{@line.id}")
    end
    redirect_to :action => "show", :id => @line.id
  end

  def del
    @line.delete
    render :json => {}
  end

  private
  def master_authorize
    @line = Line.find_by_id(params[:id])
    render :text => "该路线图不是您的，你无权操作！" if @line.admin_sid.to_i != session[:shop_id].to_i
  end

end
