# encoding: utf-8
class AdminShopTotalStatsController < ApplicationController
  include Paginate
  before_filter :admin_authorize
  layout "admin"

  def index
    hash ={}
    sort ={:_id => -1}
    hash.merge!({id: params[:id]}) unless params[:id].blank?

    @shopdaytotalstats = paginate3("ShopDayTotalStat", params[:page], hash, sort, 5)
  end

  def search
    hash ={}
    sort ={:_id => -1}
    hash.merge!({id: params[:id]}) unless params[:id].blank?
    hash.merge!({cities: params[:cities]}) unless params[:cities].blank?

    @shopdaytotalstats = paginate3("ShopDayTotalStat", params[:page], hash, sort, 5)

  end

end  