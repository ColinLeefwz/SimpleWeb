# encoding: utf-8
class AdminUserAddShopsController < ApplicationController
  include Paginate
  before_filter :agent_or_admin_authorize
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
    hash.merge!({city: params[:city]}) unless params[:city].blank?
    @shops = paginate3('shop',params[:page], hash,{_id: -1} ,10 )
  end

  def check
    @shop.lob = @shop.lo_to_lob.reverse.join(',')
    render :layout => true
  end
  
  def show
    @shop.lob = @shop.lo_to_lob.reverse.join(',')
    render :layout => true
  end

  def modify_location
    @report = ShopReport.find_by_id(params[:report_id]) if params[:report_id]
  end

  def modify_info
    @report = ShopReport.find_by_id(params[:report_id]) if params[:report_id]
  end

  def repeat
    @simaliar_shops = Shop.similar_shops(@shop)
    @report = ShopReport.find_by_id(params[:report_id]) if params[:report_id]
  end

  def confirm_delete
    @shop.update_attribute(:i, true)
    if params[:report_id].present?
      @report = ShopReport.find_by_id(params[:report_id])
      @report.update_attribute(:flag, 1)
      redirect_to "/admin_user_reports/index"
    else
      redirect_to action: "index"
    end
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
      if params[:report_id]
        report = ShopReport.find_by_id(params[:report_id])
        report.update_attribute(:flag, 1)
        redirect_to "/admin_user_reports/index"
      else
        redirect_to action: :index
      end
    else
      render :action => :modify_info
    end
  end

  def update_corrdinate
    if params[:lo] == ""
      return render json: {"success" => false}
    end

    lob = get_lob_from_params(params[:lo].split(/[;；]/))
    @shop.lo = lob
    if @shop.save
      @lo = @shop.lo
      if params[:report_id].present?
        report = ShopReport.find_by_id(params[:report_id])
        report.update_attribute(:flag, 1)
      end
      render json: {"success" => true, "lo" => format_lo(@lo) }
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
      render json: {"success" => true, "lo" => format_lo(@lo) }
    end
  end

  def destroy
    re = @shop.destory_custom? ? @shop.del_test_shop : nil
    render :json => re
  end

  def update
    lob = get_lob_from_params(params[:shop][:lob].split(/[;；]/))
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
     redirect_to action: :index
    else
      render :action => :edit
    end
  end

  def get_lob_from_params(lobs)
    if lobs.count == 1
      lob = lobs.first.split(/[,，]/).map{|s| s.to_f}.reverse
    else
      lob = lobs.inject([]){|f,s| f << s.split(/[,，]/).map { |m| m.to_f  }.reverse}
    end
    lob
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
  
  def format_lo(lob)
    if lob.first.is_a?(Array)
      lob.each do |item|
        item.reverse!
      end
      lo = lob.to_s[1...-1]
    else
      lo = lob.reverse.to_s
    end
    lo
  end
end
