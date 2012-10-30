# encoding: utf-8
class ShopCouponsController < ApplicationController
  before_filter :shop_authorize
  include Paginate
  layout 'shop'

  def index
    hash = {:shop_id => session[:shop_id]}
    sort = {}
    @coupons = paginate("Coupon", params[:page], hash, sort,10)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @coupons }
    end
  end

  # GET /coupons/1
  # GET /coupons/1.json
  def show
    @coupon = Coupon.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @coupon }
    end
  end

  # GET /coupons/new
  # GET /coupons/new.json
  def new
    @coupon = Coupon.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @coupon }
    end
  end

  # GET /coupons/1/edit
  def edit
    @coupon = Coupon.find(params[:id])
  end

  # POST /coupons
  # POST /coupons.json
  def create
    @coupon = Coupon.new(params[:coupon])
    @coupon.shop_id = session[:shop_id]
    if @coupon.save
      @coupon.gen_img
      redirect_to :action => :show, :id => @coupon.id
    else
      render :layout => true
    end
  end

  # PUT /coupons/1
  # PUT /coupons/1.json
  def update
    @coupon = Coupon.find(params[:id])

    respond_to do |format|
      if @coupon.update_attributes(params[:coupon])
        @coupon.reload.gen_img
        format.html { redirect_to :action => :show, :id => @coupon.id }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @coupon.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /coupons/1
  # DELETE /coupons/1.json
  def destroy
    @coupon = Coupon.find(params[:id])
    @coupon.destroy

    respond_to do |format|
      format.html { redirect_to '/admin_coupons' }
      format.json { head :no_content }
    end
  end

  def users
    @coupon = Coupon.find(params[:id])
    case params[:flag]
    when 'down'
      @users = @coupon.users.to_a.sort{|x,y| y['dat'] <=> x['dat']}
      @users = paginate(@users, params[:page],nil,nil,10 )
    when 'use'
      @users = @coupon.users.to_a.select{|s| s['uat']}.sort{|x,y| y['uat'] <=> x['uat']}
      @users = paginate(@users, params[:page],nil,nil,10 )
    end
  end

  def ajax_deply
    @coupon = Coupon.find(params[:id])
    text = (@coupon.deply ? '成功停用.' : '停用失败.')
    render :json => {text: text}
  end

  def ajax_del
    @coupon = Coupon.find(params[:id])
    render :json => {text: Del.insert(@coupon)}
  end

end