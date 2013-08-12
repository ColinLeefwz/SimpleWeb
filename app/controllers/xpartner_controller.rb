# coding: utf-8
class XpartnerController < ApplicationController

  def create
    line = Line.find_by_id(params[:id])
    return render :json => {error: "旅行线路编号不存在"} if line.nil?
    shop_line_partner = ShopLinePartner.find_or_new(line.id)
    shop_line_partner.partners = params[:data]
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
