# encoding: utf-8
class AdminUserReportsController < ApplicationController
  include Paginate
  before_filter :authorize
  layout "report"

  def index
    hash, sort = {flag: {"$exists" => true }}, {_id: -1}

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

    # flag: 0: 未处理 1: 已处理 2: 忽略 3: 上报
    case params[:flag]
    when '1'
      hash.merge!({flag: 1})
    when '2'
      hash.merge!({flag: 2})
    when '3'
      hash.merge!({flag: 3})
    end

    hash.merge!({name: /#{params[:name]}/}) if params[:name].present?
    hash.merge!({city: session[:city_code]}) if session[:city_code]
    if session[:city_code]
      @select_option = [['全部',''], ['已处理','1'], ['忽略', '2'], ['上报', 3]]
      hash.merge!({city: session[:city_code]})
    else
      @select_option = [['全部',''], ['已处理','1'], ['忽略', '2']]
    end
    @shop_reports = paginate3('shop_report', params[:page], hash, sort, 10)
  end

  def show
    @report = ShopReport.find(params[:id])
    @shop = @report.shop
  end

  def untreated
    hash, sort = {}, {_id: -1}

    if session[:city_code]
      hash.merge!({city: session[:city_code]})
      hash.merge!({flag: {"$exists" => false }})
    else
      hash.merge!({ "$or" => [{flag: {"$exists" => false }}, {flag: 3}] })
    end
    @shop_reports = paginate3('shop_report', params[:page], hash, sort, 10)
  end

  def update_shop_info
    @shop = Shop.find(params[:id])
    unless params[:shop_info][:addr].blank?
      info = @shop.info || ShopInfo.new()
      info._id = @shop.id
      info.addr = params[:shop_info][:addr]
      info.phone = params[:shop_info][:phone]
      info.save
    end

    @shop.name = params[:shop][:name] if params[:shop][:name]
    @shop.t = params[:shop][:t] if params[:shop][:t]

    if @shop.save
      ShopReport.where({:sid => params[:id].to_i, :flag => nil}).each do |report|
        report.update_attribute(:flag, 1)
      end
      @shop = Shop.find_primary(@shop._id)
      redirect_to action: "index"
    else
      render :action => :index
    end
  end

  def update_corrdinate
    @shop_report = ShopReport.find(params[:id])
    @shop = @shop_report.shop
    if params[:lo] == ""
      return render json: {"success" => false}
    end

    lobs = params[:lo].split(/[;；]/)
    if lobs.count == 1
      lob = lobs.first.split(/[,，]/).map{|s| s.to_f}
    else
      lob = lobs.inject([]){|f,s| f << s.split(/[,，]/).map { |m| m.to_f  }}
    end

    @shop.lo = lob
    if @shop.save
      @shop_report.update_attribute(:flag, 1)
      @lo = @shop.lo
      render json: {"success" => true, "lo" => @lo.first.is_a?(Array) ? @lo.to_s[1...-1] : @lo.to_s}
    end
  end

  def new_corrdinate
    @shop_report = ShopReport.find(params[:id])
    @shop = @shop_report.shop
    if params[:lo] == ""
      return render json: {"success" => false}
    end

    lo = params[:lo].split(/[,，]/).map{|i| i.to_f}
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

  def ignore
    @shop_report = ShopReport.find(params[:report_id])
    if @shop_report.update_attribute(:flag, 2)
      redirect_to action: "index"
    end
  end

  def reported
    @shop_report = ShopReport.find(params[:id])
    if @shop_report.update_attribute(:flag, 3)
      redirect_to action: "index"
    end
  end

  def report_del
    @shop_report = ShopReport.find(params[:id])
    @shop = @shop_report.shop
    if @shop_report.update_attribute(:flag, 1)
      @shop.shop_del
      @shop.update_attribute(:i, true)
      redirect_to action: "index"
    end
  end

  def mark_del
    @shop = Shop.find(params[:id])
    @shop.shop_del
    render :json => {result: 1}
  end

  def cancel_mark_del
    @shop = Shop.find(params[:id])
    @shop.del = nil
    @shop.save
    render :json => {result: 1}
  end

  def ajax_dis
    lob1 = params[:lob1][1...-1].split(/[,，]/).map { |m| m.to_f  }
    lob2 = params[:lob2].split(/[,，]/).map {|m| m.to_f }
    distance = Shop.new.get_distance(lob1, lob2)
    render :json => {:distance => distance}
  end

  def modify_location
    @report = ShopReport.find(params[:id])
  end

  def modify_info
    @shop = Shop.find_primary(params[:id])
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

  def authorize
    if params[:city_code].nil? && session[:city_code].nil?
      admin_authorize
    else
      city_code = params[:city_code]
      hash = Digest::SHA256.hexdigest(city_code.to_s + "dface")
      session[:city_code] = city_code if hash == params[:agent]
    end
  end

end
