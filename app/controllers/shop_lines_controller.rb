# coding: utf-8

class ShopLinesController < ApplicationController
  before_filter :shop_authorize
  before_filter :master_authorize, :only => [:show, :edit, :del, :update]
  include Paginate
  layout 'shop'

  def index
    hash = {admin_sid: session[:shop_id]}
    sort ={_id: -1}
    @lines = paginate("Line", params[:page], hash, sort,10)
  end

  def new
    
  end

  def create
    @line = Line.new
    @line.admin_sid = session[:shop_id]
    @line.name = params[:name]
    arr=[]
    params[:arr][:time].each do |t|
      shop = Shop.find_by_id(params[:arr][:id].shift)
      arr << {:time => t, :sid => shop.id, :lo => shop.lo } if shop
    end
    @line.arr = arr
    @line.save
    redirect_to :action => "show", :id => @line.id
  end

  def update
    @line.name = params[:name]
    arr=[]
    params[:arr][:time].each do |t|
      shop = Shop.find_by_id(params[:arr][:id].shift)
      arr << {:time => t, :sid => shop.id, :lo => shop.lo } if shop
    end
    @line.arr = arr
    @line.save
    redirect_to :action => "show", :id => @line.id
  end

  def del
    @line.delete
    render :json => {}
  end

  private
  def master_authorize
    @line = Line.find(params[:id])
    render :text => "该路线图不是您的，你无权操作！" if @line.admin_sid.to_i != session[:shop_id].to_i
  end

end
