# coding: utf-8
class AdminBaiduController < ApplicationController
  before_filter :admin_authorize
  include Paginate
  layout 'admin'
  def index
    hash = {}
    sort = {:_id => -1}
    unless params[:city].blank? && params[:name].blank?
      hash.merge!({:city => params[:city], :name => /#{params[:name]}/})
    end
    hash.merge!({:id => params[:id].to_i}) unless params[:id].blank?
    @shops = paginate3('Baidu', params[:page], hash , sort)
  end

  def lob_to_lo
    if request.post?
      shop = Shop.new
      shop.lob = params[:lob].split(/[,]/).map{|f| f.to_f}.reverse
      params[:lo]= shop.lob_to_lo
      shop.lo = params[:lo2].split(/[,]/).map{|f| f.to_f}
      params[:lob2] = shop.lo_to_lob.reverse
    end
  end

end

