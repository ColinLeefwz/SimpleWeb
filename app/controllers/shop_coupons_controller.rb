# encoding: utf-8
class ShopCouponsController < ApplicationController
  before_filter :shop_authorize
  include Paginate
  layout 'shop'

  def index
    hash = {:shop_id => session[:shop_id]}
    sort = {:_id => -1}
    @coupons = paginate("Coupon", params[:page], hash, sort,10)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @coupons }
    end
  end

  # GET /coupons/1
  # GET /coupons/1.json
  def show
    @coupon = Coupon.find(params[:id])
    render :file => "/shop_coupons/show2" if @coupon.t2 == 2
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

  def show_img2
    @coupon = Coupon.find(params[:id])
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
    @coupon = Coupon.find(params[:id])
  end

  def cancel_crop
    @coupon = Coupon.find(params[:id])
    @coupon.delete
    FileUtils.rm_r("public/coupon/#{@coupon.id.to_s}")
    redirect_to :action => :new
  end

  def new2
    @coupon = Coupon.new
  end

  def create2
    @coupon = Coupon.new(params[:coupon])
    @coupon.shop_id = session[:shop_id]
    @coupon.t2 = 2
    if @coupon.save
      @coupon.gen_img unless @coupon.img2.blank?
      redirect_to :action => :show, :id => @coupon.id
    else
      render :action => :new
    end
  end

  # POST /coupons
  # POST /coupons.json
  def create
    @coupon = Coupon.new(params[:coupon])
    @coupon.shop_id = session[:shop_id]
    @coupon.t2 = 1
    @coupon.process_img_upload = true if @coupon.t.to_i == 2
    if @coupon.img2.blank?
      flash[:notice]='请上传图片.'
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

  def newly_down
    down = []
    Coupon.where({:shop_id => session[:shop_id]}).each do |coupon|
      down += coupon.users.map{|m| [m['id'], m['dat'], coupon.id]}
    end
    @downs = paginate_arr(down.sort { |f,s| s[1] <=> f[1]  }, params[:page],10 )
  end

  def newly_use
    use = []
    Coupon.where({:shop_id => session[:shop_id]}).each do |coupon|
      use += coupon.users.select { |s| s['uat'] }.map{|m| [m['id'], m['uat'], coupon.id]}
    end
    @uses = paginate_arr(use.sort { |f,s| s[1] <=> f[1]  }, params[:page],10 )
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
    text = (@coupon.deply ? '成功停用.' : '停用失败.')
    render :json => {text: text}
  end

  def ajax_del
    @coupon = Coupon.find(params[:id])
    render :json => {text: Del.insert(@coupon)}
  end

end