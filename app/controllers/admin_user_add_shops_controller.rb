# encoding: utf-8
class AdminUserAddShopsController < ApplicationController
  include Paginate
  before_filter :admin_authorize
  before_filter :find_shop, except: [:index, :untreated, :post_chat]
  layout "agent"

  def index
    hash = {_id:{"$gt" => 21000000}, creator: {"$ne" => nil}, i: {"$exists" => true }}
    case params[:flag]
    when '0'
    when '1'
      hash.merge!({t: {"$gte" => 0}})
    when '2'
      hash.merge!({del: 1})
    end

    hash.merge!( {name: /#{params[:name]}/ }  )  unless params[:name].blank?
    hash.merge!({city: params[:city]}) unless params[:city].blank?
    hash.merge!({t: params[:t]}) if params[:t].present?
    @shops = paginate3('shop',params[:page], hash,{_id: -1} ,10 )
  end

  def untreated
    hash = {_id:{"$gt" => 21000000}, creator: {"$ne" => nil}, i: {"$exists" => false }}
    @shops = paginate3('shop',params[:page], hash,{_id: -1} ,10 )
  end

  def check
    @shop.lob = @shop.lo_to_lob.reverse.join(',')
    render :layout => true
  end
  
  def show
    @shop.lob = @shop.lo_to_lob.reverse.join(',')
    @model = @shop
    render :layout => true
  end

  def modify_location
    @model = @shop
  end

  def modify_info
    @model = @shop
  end

  def repeat
    @simaliar_shops = Shop.similar_shops(@shop)
    @model = @shop
  end

  def confirm_delete
    @shop.update_attribute(:i, true)
    redirect_to action: "index"
  end

  def mark_del
    @shop.shop_del
    render :json => {result: 1}
  end

  def cancel_mark_del
    @shop.del = nil
    @shop.save
    render :json => {result: 1}
  end

  def update_shop_info
    if @shop.update_attributes(params[:shop])
      redirect_to action: :index
    else
      render :action => :index
    end
  end

  def update_corrdinate
    if params[:lo] == ""
      return render json: {"success" => false}
    end

    lobs = params[:lo].split(/[;；]/)
    if lobs.count == 1
      lob = lobs.first.split(/[,，]/).map{|s| s.to_f}.reverse
    else
      lob = lobs.inject([]){|f,s| f << s.split(/[,，]/).map { |m| m.to_f  }.reverse}
    end

    @shop.lo = lob
    if @shop.save
      @lo = @shop.lo
      render json: {"success" => true, "lo" => @lo.first.is_a?(Array) ? @lo.to_s[1...-1] : @lo.to_s}
    end
  end

  def new_corrdinate
    if params[:lo] == ""
      return render json: {"success" => false}
    end

    lo = params[:lo].split(/[,，]/).map{|i| i.to_f}.reverse
    lobs = []
    if @shop.lo.first.is_a?(Array)
      @shop.lo << lo
    else
      lobs << @shop.lo
      lobs << lo
      @shop.lo = lobs
    end

    if @shop.save
      @lo = @shop.lo
      render json: {"success" => true, "lo" => @lo.first.is_a?(Array) ? @lo.to_s[1...-1] : @lo.to_s}
    end
  end

  def destroy
    re = shop.destory_custom? ? shop.del_test_shop : nil
    render :json => re
  end

  def update
    lobs = params[:shop][:lob].split(/[;；]/)
    if lobs.count == 1
      lob = lobs.first.split(/[,，]/).map{|s| s.to_f}.reverse
    else
      lob = lobs.inject([]){|f,s| f << s.split(/[,，]/).map { |m| m.to_f  }.reverse}
    end

    attrs = [:name, :addr, :tel, :t].inject({}){|_,i| _.merge({i=> params[:shop][i]})}
    attrs[:lo] = lob
    attrs[:i] = true
    if @shop.update_attributes(attrs)
      Lord.assign(@shop.id,@shop.creator, true)
      pshop = Shop.find_by_id(params[:pid])
      if pshop
        pshop.shops = pshop.shops.to_a << @shop.id.to_i unless pshop.shops.to_a.include?(@shop.id.to_i)
        pshop.save
        pshop.merge_subshops_locations
      end
      render :json => {'name' => @shop.name, 'lo' => @shop.lo, 'addr' => @shop.addr, 'lob' => @shop.lob, 'st' => @shop.show_t}
    else
      render :action => :edit
    end
  end

  def delete
    @shop.shop_del
    if @shop.update_attribute(:i, true)
      render json: {result: true}
    end
  end

  def cancel_delete
    @shop.del = nil
    render :json => {:distance => distance}
  end

  def post_chat
    Xmpp.send_chat($dduid, params[:to_uid], params[:text])
    render :text => "消息已发送"
  end

  def near
    shops = Shop.similar_shops(@shop, 60)
    data = shops.map{|shop| [ shop.id.to_i, shop.name,  shop.addr,  shop.show_t,  shop.min_distance(shop, @shop.lo)]}
    render :json => data
  end

  private
  def find_shop
    @shop = Shop.find_by_id(params[:id])
  end
end
