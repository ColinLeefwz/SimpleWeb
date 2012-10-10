# encoding: utf-8

class ShopCheckinsController < ApplicationController

  before_filter :shop_authorize
  include Paginate
  layout 'shop'

  def index
    hash = {sid: session[:shop_id]}
    hash.merge!({uid: params[:uid]}) unless params[:uid].blank?
    sort = {_id: -1}
    @checkins = paginate("Checkin", params[:page], hash, sort,5)
  end

  def show
    @checkin = Checkin.find(params[:id])
  end

  def rank
    case params[:flag]
    when 'week'
      objectid = 1.weeks.ago.beginning_of_day.to_i.to_s(16).ljust(24,'0')
    when 'month'
      objectid = 1.months.ago.beginning_of_day.to_i.to_s(16).ljust(24,'0')
    end
    shop_id = session[:shop_id]
    str = "groupCheckin(#{shop_id}, '#{objectid}')"
    @banks = Mongoid.default_session.command(eval:str)["retval"]
    @banks = @banks.sort{|f,s| s['count'] <=> f['count']}
    @banks = paginate(@banks,params[:page],{},{},5)
  end

  def rank_list
    @checkin_shop_stat  = CheckinShopStat.find(session[:shop_id])
    @banks = @checkin_shop_stat.users.sort{|b, a| a[1][0] <=> b[1][0]}
    @banks = paginate(@banks,params[:page],{},{},5)
  end

end

