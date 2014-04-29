# encoding: utf-8
class Shop3CouponsController < ApplicationController
  before_filter :shop_authorize
  before_filter :owner_authorize, :except => [:index, :new, :list, :create, :newly_down, :newly_use, :resend]
  include Paginate
  layout 'shop3'

  def index
    # hash = {:shop_id => session[:shop_id], :t2 => 1}
    # sort = {:hidden => 1, :_id => -1}
    # @coupons = paginate("Coupon", params[:page], hash, sort,10)
  end

  def list
    hash = {:shop_id => session[:shop_id], :t2 => {"$in" => [1,2]}}
    sort = {:hidden => 1,:t2 => 1,  :_id => -1}
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
  end

  # GET /coupons/1/edit
  def edit
    @coupon = Coupon.find(params[:id])
  end

  def show_img2
    @coupon = Coupon.find_primary(params[:id])
    img = MiniMagick::Image.from_file("public/#{@coupon.img2}")
    @width, @height =  img[:width],img[:height]
  end

  def crop
    @coupon = Coupon.find(params[:id])
    img = MiniMagick::Image.open("public/#{@coupon.img2}")
    img.crop "#{params[:w]}x#{params[:h]}+#{params[:x]}+#{params[:y]}"
    img.write("public/uploads/tmp/coupon_#{@coupon.id}.jpg")
    @coupon.img_tmp = "coupon_#{@coupon.id}.jpg"
    @coupon.save
    CarrierWave::Workers::StoreAsset.perform("Coupon",@coupon.id.to_s,"img")
    FileUtils.rm_r("public/coupon/#{@coupon.id.to_s}")
    redirect_to :action => :all_img, :id => @coupon.id
  end

  def all_img
    @coupon = Coupon.find_primary(params[:id])
  end

  def cancel_crop
    @coupon = Coupon.find_primary(params[:id])
    @coupon.destroy
    FileUtils.rm_r("public/coupon/#{@coupon.id.to_s}")
    redirect_to :action => :new
  end




  # POST /coupons
  # POST /coupons.json
  def create
    params[:coupon].delete("hint") if params[:hintv] == '0' #使用流程选0， hint = nil
    @coupon = Coupon.new(params[:coupon])
    @coupon.shop_id = session[:shop_id]
    @coupon.t2 = 1
    @coupon.num = Coupon.next_num(@coupon.shop_id)

    pre = params[:coupon][:img2]
    if pre.blank?
      flash.now[:notice]='请上传图片.'
      return render :action => :new
    end

    if @coupon.rule && Coupon.where({:shop_id => session[:shop_id].to_i, :hidden => {"$ne" => 1}, :t2 => 1, :rule => @coupon.rule  }).limit(1).any?
      flash.now[:notice] = "该商家已有一张有效的#{@coupon.show_rule}类型的优惠券."
      return render :action => :new
    end

    path =  FileUtils.mkdir_p('public/coupon/' + @coupon.id.to_s).first
    FileUtils.mv("public#{pre}", path+"/0.jpg")
    @coupon.img2_filename = "0.jpg"

    if @coupon.save
      @coupon.gen_img
      sadd_city_coupon_redis
      redirect_to :action => :show, :id => @coupon.id
    else
      render render :action => :new
    end
  end

  # PUT /coupons/1
  # PUT /coupons/1.json
  def update
    @coupon = Coupon.find(params[:id])
    coupon = Coupon.new(params[:coupon])

    #修改签到图文模式
    if Coupon.where({:shop_id => session[:shop_id].to_i, :hidden => nil, :t2 => 1, :_id => {"$ne" => @coupon.id}, :rule => coupon.rule  }).limit(1).any?
      flash.now[:notice] = "该商家已有一张有效的#{@coupon.show_rule}类型的优惠券."
      @coupon.name = coupon.name
      @coupon.desc = coupon.desc
      @coupon.rule = coupon.rule
      @coupon.rulev = coupon.rulev
      return  render :action => :edit
    end
   
    if @coupon.update_attributes(params[:coupon])
      @coupon.unset(:hint) if params[:hintv] == '0' #使用流程选0， hint = nil
      unless  (pre = params[:coupon][:img2]).blank?
        path = 'public/coupon/' + @coupon.id.to_s
        FileUtils.rm(path+"/0.jpg")
        FileUtils.mv("public#{pre}", path+"/0.jpg")
      end
      @coupon.gen_img
      sadd_city_coupon_redis
      redirect_to :action => :show, :id => @coupon.id
    else
      render :action => :edit
    end
  end


  def resend
    Rails.cache.fetch("CD#{params[:id]}", :expires_in => 12.hours) do
      coupon_down = CouponDown.find(params[:id])
      Xmpp.send_chat("scoupon",coupon_down.uid,coupon_down.message, coupon_down.id)  if ENV["RAILS_ENV"] == "production"
      "1"
      render :json => {}
    end
  end

  def newly_down
    hash, sort = {:sid => session[:shop_id]}, {_id: -1}
    hash.merge!(:cid => params[:cid]) unless params[:cid].blank?
    hash.merge!(:dat => {"$gt" => params[:sday], '$lt' => params[:eday]}) unless params[:sday].blank?
    @downs = paginate("CouponDown", params[:page], hash, sort, 10)
  end

  def newly_use
    hash, sort = {:sid => session[:shop_id], :uat =>{'$ne' => nil}  }, {uat: -1}
    hash.merge!(:cid => params[:cid]) unless params[:cid].blank?
    hash.merge!(:uat => {"$gt" => params[:sday], '$lt' => params[:eday]}) unless params[:sday].blank?
    @uses = paginate("CouponDown", params[:page], hash, sort, 10)
  end

  def users
    @coupon = Coupon.find(params[:id])
    case params[:flag]
    when 'down'
      @users = @coupon.users.to_a.sort{|x,y| y['dat'] <=> x['dat']}
      @users = paginate_arr(@users, params[:page],10 )
    when 'use'
      @users = @coupon.users.to_a.select{|s| s['uat']}.sort{|x,y| y['uat'] <=> x['uat']}
      @users = paginate_arr(@users, params[:page],10 )
    end
  end

  #激活优惠券
  def ajax_activate
    coupon = Coupon.find(params[:id])
    return render :json => {:text => "该商家已有一张有效的#{coupon.show_rule}类型的优惠券"} if same_rule_coupon(coupon)
    coupon.unset(:hidden)
    sadd_city_coupon_redis
    render :json => {:text => "已激活."}
  end

  #停用优惠券
  def ajax_deply
    coupon = Coupon.find(params[:id])
    text = (coupon.deply ? '已停用' : '失败了')
    srem_city_coupon_redis
    render :json => {text: text}
  end

  def ajax_del
    coupon = Coupon.find(params[:id])
    text = Del.insert(coupon)
    srem_city_coupon_redis
    render :json => {text: text}
  end

  private


  def same_rule_coupon(coupon)
    Coupon.where({:shop_id => coupon.shop_id, :hidden => nil, :t2 => coupon.t2, :_id => {"$ne" => coupon.id}, :rule => coupon.rule  }).limit(1).first
  end


  def sadd_city_coupon_redis
    $redis.sadd("ACS#{session_shop.city}", session_shop.id)
    session_shop.branchs.each do |shop|
      $redis.sadd("ACS#{shop.city}", shop.id)
    end
  end

  def srem_city_coupon_redis
    if session_shop.no_active?
      $redis.srem("ACS#{session_shop.city}", session_shop.id)
      session_shop.branchs.each do |shop|
        $redis.srem("ACS#{shop.city}", shop.id) if shop.no_active?
      end
    end
  end


  def owner_authorize
    @coupon = Coupon.find(params[:id])
    render :text => '没有权限操作此优惠券' if  @coupon && @coupon.shop_id.to_i != session[:shop_id].to_i
  end

  
  
end