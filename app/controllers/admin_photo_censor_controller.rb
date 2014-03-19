# coding: utf-8
class AdminPhotoCensorController < ApplicationController
  before_filter :admin_authorize
  include Paginate
  layout 'admin'

  def index
    hash = {}
    sort = {_id: -1}
    unless params[:shop].blank? && params[:city].blank?
      sids = Shop.where({name: /#{params[:shop]}/, city: params[:city]}).map { |m| m._id  }
      hash.merge!(room: {'$in' => sids})
    end
    hash.merge!({room: params[:sid].to_s}) unless params[:sid].blank?
    @photos = paginate3("Photo", params[:page], hash, sort, 150)
  end

  def hide
    photo = Photo.find_by_id(params[:id])
    photo.set(:hide, true)
    render json: 1
  end

  def display
    photo = Photo.find_by_id(params[:id])
    photo.unset(:hide)
    render json: 1
  end
end
