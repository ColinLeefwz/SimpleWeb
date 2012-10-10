# encoding: utf-8
class ShopShopNoticesController < ApplicationController
  before_filter :shop_authorize
  include Paginate
  layout 'shop'
  #  before_filter :operate_auth, :only => [:show, :edit,:destroy]
  # GET /shop_notices
  # GET /shop_notices.json
  def index
    hash = {shop_id: session[:shop_id]}
    hash.merge!({effect: {'1' => true, '0' => false}[params[:effect] || '1' ] }) if params[:effect] != ''
    sort = {ord: 1}
    @shop_notices = paginate("ShopNotice", params[:page], hash, sort)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @shop_notices.map{|sn| {id:sn._id, title:sn.title} }.to_json }
    end
  end

  # GET /shop_notices/1
  # GET /shop_notices/1.json
  def show
    @shop_notice = ShopNotice.find(params[:id])
    return  render :text => "你没有权限查看此公告"  if @shop_notice.shop_id != session[:shop_id]

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @shop_notice }
    end
  end

  # GET /shop_notices/new
  # GET /shop_notices/new.json
  def new
    @shop_notice = ShopNotice.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @shop_notice }
    end
  end

  def top
    @shop_notice = ShopNotice.find(params[:id])
    return render :text => "你没有权限查看此公告"  if @shop_notice.shop_id != session[:shop_id]
    @shop_notice.update_attribute(:ord, 1)
    @shop_notice.reload.reord
    redirect_to shop_shop_notices_url
  end

  def edit
    @shop_notice = ShopNotice.find(params[:id])
    return render :text => "你没有权限查看此公告"  if @shop_notice.shop_id != session[:shop_id]
  end

  # GET /shop_notices/1/edit
  #  def edit
  #    @shop_notice = ShopNotice.find(params[:id])
  #    render :text => "你没有权限修改此公告"  if @shop_notice != session_shop.id
  #  end

  # POST /shop_notices
  # POST /shop_notices.json
  def create
    @shop_notice = ShopNotice.new(params[:shop_notice])
    @shop_notice.shop_id = session[:shop_id]
    respond_to do |format|
      if @shop_notice.save
        @shop_notice.reord
        format.html { redirect_to shop_shop_notice_path(@shop_notice), :notice => 'Shop notice was successfully created.' }
        format.json { render :json => @shop_notice, :status => :created, :location => @shop_notice }
      else
        format.html { render :action => "new" }
        format.json { render :json => @shop_notice.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /shop_notices/1
  # PUT /shop_notices/1.json
  def update
    @shop_notice = ShopNotice.find(params[:id])
    return  render :text => "你没有权限查看此公告"  if @shop_notice.shop_id != session[:shop_id]
    respond_to do |format|
      if @shop_notice.update_attributes(params[:shop_notice])
        format.html { redirect_to shop_shop_notice_path(@shop_notice), :notice => 'Shop notice was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @shop_notice.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /shop_notices/1
  # DELETE /shop_notices/1.json
  def dest
    @shop_notice = ShopNotice.find(params[:id])
    return  render :text => "你没有权限查看此公告"  if @shop_notice.shop_id != session[:shop_id]
    @shop_notice.update_attribute(:effect, :false)
    respond_to do |format|
      format.html { redirect_to shop_shop_notices_url }
      format.json { head :no_content }
    end
  end

end