# coding: utf-8
class AdminShopPhotosController < ApplicationController
  include Paginate
  before_filter :admin_authorize
  layout "admin"

  def index
    hash ={}
    sort ={:_id => -1}

    if !params[:city].blank? && !params[:shop].blank?
      sids = Shop.where({:name => /#{params[:shop]}/, :city => params[:city]}).only(:_id).map { |m| m._id.to_i.to_s }
      hash.merge!(:room => {'$in' => sids})
    end

    hash.merge!(:room => params[:sid].to_i.to_s) unless params[:sid].blank?

    @photos = paginate3("Photo", params[:page], hash, sort)
  end

  def ajax_del
    photo = Photo.find(params[:id])
    photo.delete
    render :json => {:text => '删除成功'}
  end
end
