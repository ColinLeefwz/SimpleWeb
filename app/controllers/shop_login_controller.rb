# coding: utf-8

class ShopLoginController < ApplicationController
  before_filter :shop_authorize, :except => [:login, :find_shop]
  include Paginate

  def index
    render :layout => "shop"
  end


  def login
    return redirect_to :action  => 'index' if session[:shop_id]
    if request.post?
      shop =  Shop.where(:_id => params[:id]).first
      return flash.now[:notice] = 'id没有找到.' if shop.nil?
      return flash.now[:notice] = '密码还没有开通.' if shop.password.blank?
      return flash.now[:notice] = '密码错误.' if shop.password != params[:password]
      session[:shop_id] = shop.id
      cookies[:id], cookies[:password] =params[:id],params[:password] if params[:remember]=='1'
      o_uri_path, session[:o_uri_path] = session[:o_uri_path]||'/shop_login/index' , nil
      redirect_to o_uri_path
    end
  end

  def logout
    session[:shop_id] = nil
    redirect_to :action => :login
  end

  def find_shop
    shop = Shop.find_by_id(params[:id])
    render :json => {:text => shop ? shop.name : '错误id.'}
  end

  def gchat
    @chats = paginate_arr(session_shop.gchat, params[:page], 15)
    render :layout => "shop"
  end

end

