# coding: utf-8

class ShopBansController < ApplicationController
  before_filter :shop_authorize
  layout 'shop'
  include Paginate

  def index
    @shop_ban = ShopBan.find2(session[:shop_id].to_i)
    @bans = paginate_arr(@shop_ban.users, params[:page] )
    @users = @bans.map{|b| User.find_by_id(b)}.to_a
  end


  def unban
    @shop_ban = ShopBan.find2(session[:shop_id].to_i)
    @shop_ban.users.delete(params[:uid])
    @shop_ban.save
    url = {:action => "index"}
    url.merge!(:page => params[:page]) unless params[:page].blank?
    redirect_to  url
  end


end
