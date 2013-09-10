# coding: utf-8
class AdminShopPartnersController < ApplicationController
  include Paginate
  before_filter :admin_authorize
  layout "admin"

  def index
    @shop_partner = ShopPartner.find_or_new(params[:id])
    partners = paginate_arr(@shop_partner.partners.to_a, params[:page])
    @shops = Shop.where(_id: {"$in" => partners.map{|m| m[0]}})
  end

  def ajax_del_partner
    shop_partner = ShopPartner.find(params[:id])
    shop_partner.partners.delete_if{|pa| pa[0] == params[:partner_id]}
    shop_partner.save
    render :json => ''
  end


  def ajax_add_partner
    shop = Shop.find_by_id(params[:id])
    shop_partner = ShopPartner.find_or_new(params[:pid])
    
    if shop && params[:id]!=params[:pid]
      partners = shop_partner.partners
      if partners.any?{|pa| pa[0] == params[:id]}
        text = "已是合作商家"
      else
        partners << [params[:id], Time.now]
        shop_partner.partners = partners
        shop_partner.save
        text = "添加成功"
      end
    else
      text = '商家id错误'
    end
    render :json => {:text => text}
  end

  def find_shops
    @shop_partner = ShopPartner.find_or_new(params[:id])

    if !params[:city].blank? && !params[:name].blank?
     hash = {del: {"$exists" => false}}
      if params[:fun] == 'true'
        hash.merge!({:city => params[:city], :name => params[:name]})
      else
        hash.merge!({:city => params[:city], :name => /#{params[:name]}/})
      end
      @shops = Shop.where(hash).limit(300).reject{|s| s.id == @shop_partner.id}
    else
      @shops = []
    end
  end

  def bat_add_sub
    shop_partner = ShopPartner.find_or_new(params[:id])
    cancel = params[:ids].to_a - params[:shop_ids].to_a
    check = params[:shop_ids].to_a - params[:ids].to_a
    cancel.each{|c| shop_partner.partners.delete_if{|pa|  pa[0] == c}}
    check.each{|c|  shop_partner.partners << [c, Time.now]}
    shop_partner.save
    redirect_to :action => "index", :id => params[:id]
  end


end
