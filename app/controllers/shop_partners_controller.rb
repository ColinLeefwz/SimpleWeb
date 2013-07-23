# coding: utf-8
class ShopPartnersController < ApplicationController
  before_filter :shop_authorize
  include Paginate
  layout 'shop'

  def index
    shop_partner = ShopPartner.find_primary(session[:shop_id])
    if shop_partner && !shop_partner.partners.blank?
      @shopids = paginate_arr(shop_partner.partners, 1, 15)
      @shops = Shop.find_by_id(@shopids.map{|m| m[0].to_i}).to_a
    else
      @shops =paginate_arr([]).to_a
    end
  end

  def del
    shop_partner = ShopPartner.find_by_id(session[:shop_id])
    spp=shop_partner.partners
    shop_partner.partners = spp.delete_if{|d| d[0].to_s == params[:id]}
    shop_partner.save
    render :json => {}
  end

  def new
    
  end

  def create
    shop_partner = ShopPartner.find_or_new(session[:shop_id])
    spp=shop_partner.partners
    ids = params[:ids].uniq - params[:errids].to_a
    ids.delete_if{|id| id.blank? ||  spp.find{|s| s[0].to_s == id}}
    shop_partner.partners = spp + ids.map{|m| [m, Time.now]}
    shop_partner.save
    redirect_to :action => "index"
  end

  def find_shop
    shop = Shop.find_by_id(params[:id])
    if shop
      render :json => {:name => shop.name, :city => shop.city_fullname, :addr => shop.addr}
    else
      render :json => {:text => '没有找到该商家'}
    end
  end

end
