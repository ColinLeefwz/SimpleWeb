# coding: utf-8

class Shop3BansController < ApplicationController
  before_filter :shop_authorize
  layout 'shop3'
  include Paginate

  def index
    shop_ban = ShopBan.find_by_id(session[:shop_id].to_i)
    if shop_ban
      bans = paginate_arr(shop_ban.users.to_a, params[:page],10 ).to_a
      @users = bans.map{|b| User.find_by_id(b)}.compact
    else
      @users  = paginate_arr([],params[:page])
    end
  end


  def unban
    shop_ban = ShopBan.find_by_id(session[:shop_id].to_i)
    shop_ban.users.delete(params[:uid])
    shop_ban.save
    render :json => {}
  end


end
