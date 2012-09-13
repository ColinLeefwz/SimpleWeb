# encoding: utf-8

class ShopCheckinsController < ApplicationController
  before_filter :shop_authorize

  def index
    @checkins = Checkin.where({sid: session[:shop_id]}).sort({_id: -1})
  end

  def show
    @checkin = Checkin.find(params[:id])
  end

  def bank
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
  end



end

