# coding: utf-8
class XshopController < ApplicationController

  def create
    errmsg = blank_check(:name, :id, :lat, :lng)
    return render :json => {error: errmsg} if errmsg
    return render :json => {error:  "id已有"} if Shop.find_by_tid(params[:id].to_i)
    shop = Shop.new(name: params[:name], lo: [params[:lat].to_f, params[:lng].to_f], t: params[:type], tid: params[:id] )
    shop.city = shop.get_city
    shops = Shop.similar_shops(shop, 75)
    if shops.blank?
      shop.id = Shop.next_id
      shop.save
      shop_info = ShopInfo.new(addr: params[:addr])
      shop_info.id = shop.id
      shop_info.save
    else
      shop = shops.first
      shop.update_attribute(:tid, params[:id])
      info = shop.info
      info.set(:data, params.slice(:name, :lat, :lng, :type, :addr, :id))
    end

    shop_partner = ShopPartner.find_or_new(21834762)
    shop_partner.partners += [[shop.id, Time.now]]
    shop_partner.save

    render :json => shop.reload.travel_attrs
  end

  def find
    return render :json => {error: "id必填"} if params[:id].blank?
    shop = Shop.find_by_tid(params[:id])
    if shop
      render :json => shop.travel_attrs
    else
      render :json => {}
    end
  end

  def blank_check(*arr)
    arr.each{|a| return "#{a.to_s}必填" if params[a].blank?}
    return nil
  end

end
