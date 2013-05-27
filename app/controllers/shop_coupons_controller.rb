# encoding: utf-8
class ShopCouponsController < ApplicationController
  before_filter :shop_authorize
  before_filter :owner_authorize, :except => [:index, :new, :create, :newly_down, :newly_use, :resend]
  include Paginate
  layout 'shop'

  def index
    hash = {:shop_id => session[:shop_id], :t2 => 1}
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
  end

  # GET /coupons/1/edit
  def edit
    @coupon = Coupon.find(params[:id])
  end

  def show_img2
    @coupon = Coupon.find_primary(params[:id])
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
    @coupon = Coupon.find(params[:id])
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
    @coupon.process_img_upload = true if @coupon.t.to_i == 2
    if @coupon.img2.blank?
      flash.now[:notice]='请上传图片.'
      return render :layout => true
    end

    #    debugger
    if @coupon.rule && Coupon.where({:shop_id => session[:shop_id].to_i, :hidden => {"$ne" => 1}, :t2 => 1, :rule => @coupon.rule  }).limit(1).any?
      flash.now[:notice] = "该商家已有一张有效的#{@coupon.show_rule}类型的优惠券."
      return render :layout => true
    end

    if @coupon.save
      if @coupon.t.to_i == 1
        @coupon.gen_img if @coupon.t.to_i == 1
        redirect_to :action => :show, :id => @coupon.id
      else
        redirect_to :action => :show_img2, :id => @coupon.id
      end
    else
      render :layout => true
    end
  end

  # PUT /coupons/1
  # PUT /coupons/1.json
  def update
    @coupon = Coupon.find(params[:id])
    coupon = Coupon.new(params[:coupon])

    #修改签到全图模式,
    if  @coupon.t.to_i == 2
      if coupon.img2.blank?
        return render :action => 'all_img', :id => @coupon.id if coupon.rule.blank?
        
        if Coupon.where({:shop_id => session[:shop_id].to_i, :hidden => nil, :t2 => 1,  :_id => {"$ne" => @coupon.id},  :rule => coupon.rule  }).limit(1).any?
          flash.now[:notice] = "该商家已有一张有效的#{coupon.show_rule}类型的优惠券."
          return render :action => 'all_img', :id => @coupon.id
        end
      else
        @coupon.process_img_upload = true
        @coupon.update_attributes(params[:coupon])
        return redirect_to :action => :show_img2, :id => @coupon.id
      end
    end

    #修改签到图文模式
    if  @coupon.t.to_i == 1
      if Coupon.where({:shop_id => session[:shop_id].to_i, :hidden => nil, :t2 => 1, :_id => {"$ne" => @coupon.id}, :rule => coupon.rule  }).limit(1).any?
        flash.now[:notice] = "该商家已有一张有效的#{@coupon.show_rule}类型的优惠券."
        @coupon.name = coupon.name
        @coupon.desc = coupon.desc
        @coupon.rule = coupon.rule
        @coupon.rulev = coupon.rulev
        return  render :action => :edit
      end
    end
   
    if @coupon.update_attributes(params[:coupon])
      @coupon.unset(:hint) if params[:hintv] == '0' #使用流程选0， hint = nil
      @coupon.gen_img if @coupon.t.to_i == 1
      redirect_to :action => :show, :id => @coupon.id
    else
      render :action => :edit
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
    hash.merge!(:dat => {"$gt" => params[:date], '$lt' => params[:date].succ}) unless params[:date].blank?
    @downs = paginate("CouponDown", params[:page], hash, sort)
  end

  def newly_use
    hash, sort = {:sid => session[:shop_id], :uat =>{'$ne' => nil}  }, {uat: -1}
    hash.merge!(:cid => params[:cid]) unless params[:cid].blank?
    hash.merge!(:uat => {"$gt" => params[:date], '$lt' => params[:date].succ}) unless params[:date].blank?
    @uses = paginate("CouponDown", params[:page], hash, sort)
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

  def ajax_deply
    @coupon = Coupon.find(params[:id])
    text = (@coupon.deply ? '<span class="gray">已停用</span>' : '<span class="red">失败了</span>')
    render :json => {text: text}
  end

  def ajax_del
    @coupon = Coupon.find(params[:id])
    render :json => {text: Del.insert(@coupon)}
  end

  private
  def owner_authorize
    @coupon = Coupon.find(params[:id])
    render :text => '没有权限操作此优惠券' if  @coupon && @coupon.shop_id.to_i != session[:shop_id].to_i
  end
end