# encoding: utf-8

class Shop3CheckinsController < ApplicationController
  

  before_filter :shop_authorize
  include Paginate
  layout 'shop3'

  def index
    hash = {sid: session[:shop_id]}
    unless params[:name].blank?
      uids = User.where(:name => /#{params[:name]}/).only(:_id).map { |m| m._id }
      hash.merge!({uid: {'$in' => uids}})
    end
    hash.merge!({uid: params[:uid]}) unless params[:uid].blank?
    
    sort = {_id: -1}
    @checkins = paginate2("Checkin", params[:page], hash, sort,10)
  end

  def show
    @checkin = Checkin.find(params[:id])
  end

  def user
    @user = User.find_by_id(params[:uid])
    @coupon_downs = CouponDown.where({sid: session[:shop_id], uid: @user.id}).sort({_id: -1})
  end

  def rank
    case params[:flag]
    when 'week'
      objectid = 1.weeks.ago.beginning_of_day.to_i.to_s(16).ljust(24,'0')
    when 'month'
      objectid = 1.months.ago.beginning_of_day.to_i.to_s(16).ljust(24,'0')
    end
    gc = Checkin.where({sid: session[:shop_id], _id: {'$gte' => objectid }}).group_by{|c| c.uid}
    @banks = gc.map { |k,v| [k, v.count] }.sort{|f,s| s[1] <=> f[1]}
    @banks = paginate_arr(@banks,params[:page])

    #    shop_id = session[:shop_id]
    #    str = "groupCheckin(#{shop_id}, '#{objectid}')"
    #    @banks = Mongoid.default_session.command(eval:str)["retval"]
    #    @banks = @banks.sort{|f,s| s['count'] <=> f['count']}
    #
  end

  def rank_list
    @checkin_shop_stat  = CheckinShopStat.find_by_id(session[:shop_id])
    if @checkin_shop_stat
      @banks = @checkin_shop_stat.users.sort{|b, a| a[1][0] <=> b[1][0]}
      @banks = paginate_arr(@banks,params[:page])
    else
      @banks = paginate_arr([],params[:page])
    end
  end

  def do_ban
    ban = session_shop.ban || ShopBan.new
    ban._id = session[:shop_id].to_i
    users = ban.users.to_a
    (ban.users = users << params[:uid] ) if users.index(params[:uid]).nil?
    ban.save
    redirect_to :action => "index", :name => params[:name], :page => params[:page]
  end

  def unban
    ban = session_shop.ban
    ban.users.delete(params[:uid])
    ban.save
    redirect_to :action => "index", :name => params[:name], :page => params[:page]
  end

end

