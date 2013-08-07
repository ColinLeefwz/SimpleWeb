# coding: utf-8

class ShopBansController < ApplicationController
  before_filter :shop_authorize
  layout 'shop'
  include Paginate

  def index
    shop_ban = ShopBan.find_by_id(session[:shop_id].to_i)
    if shop_ban
       bans = paginate_arr(shop_ban.users.to_a, params[:page] ).to_a
       @users = bans.map{|b| User.find_by_id(b)}.compact
    else
      @users =[]
    end
  end


  def unban
    shop_ban = ShopBan.find_by_id(session[:shop_id].to_i)
    shop_ban.users.delete(params[:uid])
    shop_ban.save
    url = {:action => "index"}
    url.merge!(:page => params[:page]) unless params[:page].blank?
    redirect_to  url
  end


end
