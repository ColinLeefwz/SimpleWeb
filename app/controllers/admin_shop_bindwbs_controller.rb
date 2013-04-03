# coding: utf-8
class AdminShopBindwbsController < ApplicationController
  include Paginate
  before_filter :admin_authorize
  layout "admin"

  def index
    hash ={}
    sort ={:_id => -1}

    if !params[:city].blank? && !params[:shop].blank?
      sids = Shop.where({:name => /#{params[:shop]}/, :city => params[:city]}).only(:_id).map { |m| m._id.to_i.to_s }
      hash.merge!(:_id => {'$in' => sids})
    end

    hash.merge!(:_id => params[:sid].to_i.to_s) unless params[:sid].blank?

    @bind_wbs = paginate3("BindWb", params[:page], hash, sort)
  end

end
