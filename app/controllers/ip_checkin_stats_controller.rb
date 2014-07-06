# encoding: utf-8

class IpCheckinStatsController < ApplicationController
  include Paginate
  before_filter :admin_authorize
  layout "admin"

  def index
    sort = {}
    hash = {}
    unless params[:ip].blank?
      ip = params[:ip].gsub('.','\.')
      hash.merge!({_id: /^#{ip}/})
    end

    case params[:order].to_s
    when ''
      sort.merge!({ctotal: -1})
    when '1'
      sort.merge!({ctotal: 1})
    when '2'
      sort.merge!({_id: -1})
    when '3'
      sort.merge!({_id: 1})
    when '4'
      sort.merge!({stotal: -1})
    when '5'
      sort.merge!({stotal: 1})
    when '6'
      sort.merge!({utotal: -1})
    when '7'
      sort.merge!({utotal: 1})
    end


    @checkin_ip_stats = paginate3("CheckinIpStat", params[:page], hash, sort )
  end

  def show_shops
    @checkin_ip_stat = CheckinIpStat.find(params[:id])
    @shops =  paginate_arr(@checkin_ip_stat.shops, params[:page])
  end

  def show_users
    @checkin_ip_stat = CheckinIpStat.find(params[:id])
    @users =  paginate_arr(@checkin_ip_stat.users, params[:page])
  end

  def checkin_list
    hash = {ip: params[:id]}
    @checkin_ip_stat = CheckinIpStat.find(params[:id])
    @checkins = paginate('checkin', params[:page], hash)
  end

end

