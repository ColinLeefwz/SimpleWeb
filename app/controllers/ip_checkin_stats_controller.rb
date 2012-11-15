# encoding: utf-8

class IpCheckinStatsController < ApplicationController
  include Paginate
  before_filter :admin_authorize
  layout "admin"

  def index
    sort = {stotal: -1}
    hash = {}
    @checkin_ip_stats = paginate("CheckinIpStat", params[:page], hash, sort )
  end

  def show_shops
    @checkin_ip_stat = CheckinIpStat.find(params[:id])
    @shops =  paginate_arr(@checkin_ip_stat.shops, params[:page])
  end

  def checkin_list
    hash = {ip: params[:id]}
    @checkin_ip_stat = CheckinIpStat.find(params[:id])
    @checkins = paginate('checkin', params[:page], hash)
  end

end

