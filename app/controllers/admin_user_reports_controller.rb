# encoding: utf-8
class AdminUserReportsController < ApplicationController
  include Paginate
  before_filter :admin_authorize
  layout "report"

  def index
    hash, sort = {flag: nil}, {}
    case params[:type]
    when '1'
      hash.merge!({type: "地点位置错误"})
    when '2'
      hash.merge!({type: "地点信息错误"})
    when '3'
      hash.merge!({type: "地点不存在"})
    when '4'
      hash.merge!({type: "地点重复"})
    end

    case params[:flag]
    when '0'
      hash.merge!({flag: {"$exists" => false}})
    when '1'
      hash.merge!({flag: 1})
    when '2'
      hash.merge!({flag: 2})
    end

    @shop_reports = paginate3('shop_report', params[:page], hash, sort)
  end

  def show
    @shop_report = ShopReport.find(params[:id])
    @shop = @shop_report.shop
  end


  def update
    @shop = Shop.find(params[:id])
    shop = Shop.new(params[:shop])
    if shop.lob.blank?
      shop.lob = @shop.lo_to_lob.reverse.join(',')
    else
      lobs = shop.lob.split(/[;；]/)
      @shop.lob = lobs.inject([]){|f,s| f << s.split(/[,，]/).map { |m| m.to_f  }.reverse}
      @shop.lo = @shop.lob.map{|m| Shop.lob_to_lo(m)}
      @shop.unset(:lob)

    end

    unless params[:shop][:addr].blank?
      info = @shop.info || ShopInfo.new()
      info._id = @shop.id
      info.addr = params[:shop][:addr]
      info.save
    end

    @shop.name = shop.name
    @shop.t = shop.t
    if @shop.save
      ShopReport.where({:sid => params[:id].to_i, :flag => nil}).each do |report|
        report.update_attribute(:flag, 3)
      end
      @shop = Shop.find_primary(@shop._id)
      render :json => {'name' => @shop.name, 'lo' => @shop.lo, 'addr' => @shop.addr, 'lob' => shop.lob, 'st' => @shop.show_t}
    else
      render :action => :edit
    end

  end

  def update_corrdinate
    @shop_report = ShopReport.find(params[:id])
    @shop = @shop_report.shop
    if @shop.update_attribute(:lo, params[:lo][1..-2].split(",").map{|i| i.to_f})
      @shop_report.update_attribute(:flag, 1)
      render json: {"success" => true, "lo" => @shop.lo}
    end
  end

  def ignore
    @shop_report = ShopReport.find(params[:report_id])
    if @shop_report.update_attribute(:flag, 2)
      render json: {"success" => true}
    end
  end

  def repot_del
    @shop_report = ShopReport.find(params[:id])
    @shop = @shop_report.shop
    if @shop_report.update_attribute(:flag, 1)
      @shop.shop_del
      @shop.update_attribute(:i, true)
      redirect_to action: "index"
    end
  end

  def modify_location
    @report = ShopReport.find(params[:id])
  end

  def modify_infor

  end

  def repeat
    @shop_report = ShopReport.find(params[:id])
    @shop = @shop_report.shop
    @simaliar_shops = Shop.similar_shops(@shop)
  end

  def confirm
    @shop_report = ShopReport.find(params[:id])
    @shop_report.update_attribute(:flag, 1)
    redirect_to action: "index"
  end

  def post_chat
    Xmpp.send_chat($dduid, params[:to_uid], params[:text])
    render :text => "消息已发送"
  end

  def ajax_distort
    ShopReport.where({:sid => params[:sid].to_i, :flag => nil}).each do |report|
      report.update_attribute(:flag, 2)
    end
    render :json => ''
  end


end
