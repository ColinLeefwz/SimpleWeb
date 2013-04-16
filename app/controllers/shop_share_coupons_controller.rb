# encoding: utf-8
class ShopShareCouponsController < ApplicationController
  before_filter :shop_authorize
  include Paginate
  layout 'shop'

  def index
    hash = {:shop_id => session[:shop_id], :t2 => 2}
    sort = {:hidden => 1, :_id => -1}
    @coupons = paginate("Coupon", params[:page], hash, sort,10)
  end

  # GET /coupons/1
  # GET /coupons/1.json
  def show
    @coupon = Coupon.find_primary(params[:id])
  end

  # GET /coupons/new
  # GET /coupons/new.json
  def new
    @coupon = Coupon.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @coupon }
    end
  end

  # GET /coupons/1/edit
  def edit
    @coupon = Coupon.find(params[:id])
  end

  def new
    @coupon = Coupon.new
  end

  def create
    @coupon = Coupon.new(params[:coupon])
    @coupon.shop_id = session[:shop_id]
    @coupon.t2 = 2

    unless Coupon.where({:shop_id => session[:shop_id].to_i, :hidden => nil, :t2 => 2}).limit(1).blank?
      return flash.now[:notice] = '该商家已有一张未停用分享类优惠券.'
    end

    if @coupon.t.to_i == 2
      return flash.now[:notice] = '请上传图片.' if @coupon.img2.blank?
    end

    if @coupon.save
      case @coupon.t.to_i
      when 1
        @coupon.gen_img unless @coupon.img2.blank?
      when 2
        @coupon.process_img_upload = true
        FileUtils.cp("public/#{@coupon.img2}", "public/uploads/tmp/coupon_#{@coupon.id}.jpg")
        FileUtils.rm_r("public/coupon/#{@coupon.id.to_s}")
        @coupon.img_tmp = "coupon_#{@coupon.id}.jpg"
        @coupon.save
        CarrierWave::Workers::StoreAsset.perform("Coupon",@coupon.id.to_s,"img")
      end
      redirect_to :action => :show, :id => @coupon.id
    else
      flash.now[:notice] = '发布失败.'
    end
  end

 
  # PUT /coupons/1
  # PUT /coupons/1.json
  def update
    @coupon = Coupon.find(params[:id])
    coupon = Coupon.new(params[:coupon])

    #修改分享类全图模式
    if @coupon.t.to_i ==2 && !coupon.img2.blank?
      @coupon.update_attributes(params[:coupon])
      @coupon.process_img_upload = true
      FileUtils.cp("public/#{@coupon.img2}", "public/uploads/tmp/coupon_#{@coupon.id}.jpg")
      FileUtils.rm_r("public/coupon/#{@coupon.id.to_s}")
      @coupon.img_tmp = "coupon_#{@coupon.id}.jpg"
      @coupon.save
      CarrierWave::Workers::StoreAsset.perform("Coupon",@coupon.id.to_s,"img")
      return redirect_to :action => :show, :id => @coupon.id
    end
   
    if @coupon.update_attributes(params[:coupon])
      if @coupon.t.to_i == 1
        @coupon.gen_img if !@coupon.img.blank? || !@coupon.img2.blank?
      end

      redirect_to :action => :show, :id => @coupon.id
    else
      render :action => :edit
    end
  end

  def ajax_activate
    @coupon = Coupon.find(params[:id])
    @coupon.unset(:hidden)
    render :json => {:text => "已激活."}
  end

end