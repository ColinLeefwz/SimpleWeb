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
    case params[:correspond].to_i
    when 1
      hash.merge!({:baidu_id => {"$exists" => true} })
    when 2
      hash.merge!({:baidu_id => {"$exists" => false} })
    end

    @sina_pois = paginate("SinaPoi", params[:page], hash, sort, 20  )
  end

  def ajax_add_baidu_id
    @sina_poi = SinaPoi.find(params[:id])
    @sina_poi.update_attribute(:baidu_id, params[:baidu_id].to_i)
    str = "<a href='/admin_baidu?id=#{@sina_poi.baidu_id}'>#{Baidu.find(@sina_poi.baidu_id).name}</a>"
    render :json => {:text => str}
  end


  def near
    @sina_poi = SinaPoi.find(params[:id])
    @shops = Baidu.where({:lo => {"$within" => {"$center" => [[@sina_poi.lat.to_f, @sina_poi.lon.to_f], 0.01]}}}).select{|m| name_similar(m.name, @sina_poi.title)}
  end

  private
  def name_similar(bn, wbn)
    bna = bn.split(/[()]/)
    wbna = wbn.split(/[()]/)
    bn1 = bna.join('').scan(/[\u4e00-\u9fa5]|[^\u4e00-\u9fa5]+/)
    wbn1 = wbna.join('').scan(/[\u4e00-\u9fa5]|[^\u4e00-\u9fa5]+/)
    if (bn1&wbn1).length >= (bn1.length < wbn1.length ? bn1.length : wbn1.length )/2.0
      return true
    end
    bn1 = bna.first.scan(/[\u4e00-\u9fa5]|[^\u4e00-\u9fa5]+/)
    wbn1 = wbna.first.scan(/[\u4e00-\u9fa5]|[^\u4e00-\u9fa5]+/)
    if (bn1&wbn1).length >= (bn1.length < wbn1.length ? bn1.length : wbn1.length )/2.0
      return true
    end

    return false
  end
end