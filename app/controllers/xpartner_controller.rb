# coding: utf-8
class XpartnerController < ApplicationController

  def create
    line = Line.find_by_id(params[:id])
    return render :json => {error: "旅行线路编号不存在"} if line.nil?
    shop_line_partner = ShopLinePartner.find_by_id(line.id)
    return render :json =>{"error" => "旅行线路的合作商家已存在"} if shop_line_partner
    shop_line_partner = ShopLinePartner.new
    shop_line_partner.id = line.id
    hash = {}
    tid=nil
    begin
      params[:data].each do |key, value|
        hash[Shop.find_by_tid(tid = key).id.to_s] = value.map{|m|  Shop.find_by_tid(tid=m).id.to_s}
      end
    rescue
      return render :json => {"error" => "id#{tid}不存在"}
    end

    shop_line_partner.partners = hash
    shop_line_partner.save
    render :json => {'ok' => shop_line_partner.id }
  end


  def find
    return render :json => {error: "id必填"} if params[:id].blank?
    shop_line_partner = ShopLinePartner.find_by_id(params[:id])
    if shop_line_partner
      render :json => {data: shop_line_partner.attributes}
    else
      render :json => {error: "id不存在"}
    end
  end

end
