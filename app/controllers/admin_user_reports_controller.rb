# encoding: utf-8
class AdminUserReportsController < ApplicationController
  include Paginate
  before_filter :agent_or_admin_authorize
  layout "agent"

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
    if session[:city_code].present?
      @select_option = [['全部',''], ['已处理','1'], ['忽略', '2'], ['上报', '3']]
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
end
