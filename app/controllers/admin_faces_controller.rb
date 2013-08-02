# coding: utf-8

class AdminFacesController < ApplicationController
  include Paginate
  before_filter :admin_authorize
  layout "admin"

  def index
    hash = {}
    sort = {}
    hash.merge!({_id: params[:uid]}) unless params[:uid].blank?
    sel = case params[:sel]
    when "2"
      {"data.attribute.gender.confidence" => 1}
    when "3"
      {"data.attribute.gender.confidence" => -1}
    when "4"
      {"data.attribute.age.value" => 1}
    when "5"
      {"data.attribute.age.value" => -1}
    else
      {}
    end
    sort.merge!(sel)
    sort.merge!({_id:  -1})
    @faces = paginate3('Face',params[:page], hash, sort,100 )
  end
 
end
