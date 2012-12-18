class AdminSinaPoisController < ApplicationController
  include Paginate
  before_filter :admin_authorize
  layout "admin"

  def index
    hash = {}
    sort = {}
    unless params[:city].blank? && params[:title].blank?
      hash.merge!({:city=> params[:city], :title => /#{params[:title]}/})
    end
    hash.merge!({:_id => params[:id] }) unless params[:id].blank?

    @sina_pois = paginate("SinaPoi", params[:page], hash, sort, 20  )
  end

  def ajax_add_baidu_id
    @sina_poi = SinaPoi.find(params[:id])
    @sina_poi.update_attribute(:baidu_id, params[:baidu_id].to_i)
    str = "<a href='/admin_baidu?id=#{@sina_poi.baidu_id}'>#{Baidu.find(@sina_poi.baidu_id).name}</a>"
    render :json => {:text => str}
  end

end