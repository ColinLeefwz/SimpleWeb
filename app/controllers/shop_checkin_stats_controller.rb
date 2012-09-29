# encoding: utf-8

class ShopCheckinStatsController < ApplicationController
  include Paginate
  before_filter :admin_authorize
  layout "admin"

  def index
    hash = {}
    sort = {utotal: -1}
    @checkin_shop_stats =  paginate("CheckinShopStat", params[:page], hash, sort)
  end

  def show_users
    @checkin_shop_stat = CheckinShopStat.find(params[:id])
    @users = @checkin_shop_stat.users
  end

  def show_ips
    @checkin_shop_stat = CheckinShopStat.find(params[:id])
    @ips = @checkin_shop_stat.ips
  end

  def users_list
    hash = {sid: params[:sid]}
    hash.merge!(uid: params[:uid]) unless params[:uid].blank?
    @checkins = paginate("Checkin", params[:page], hash, {})
    @checkin_shop_stat = CheckinShopStat.find(params[:sid])
  end

  def ips_list
    @checkins = Checkin.where({sid: params[:sid], ip: params[:ip] })
    @checkin_shop_stat = CheckinShopStat.find(params[:sid])
  end

end

