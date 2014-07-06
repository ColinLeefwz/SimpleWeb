# coding: utf-8

class AdminRekognitionsController < ApplicationController
  include Paginate
  before_filter :admin_authorize
  layout "admin"

  def index
    hash = {}
    sort = {}
    hash.merge!({_id: params[:uid]}) unless params[:uid].blank?
    sel = case params[:sel]
    when "0"
      {"data.confidence" => 1}
    when "1"
      {"data.confidence" => -1}
    when "2"
      {"data.sex" => 1}
    when "3"
      {"data.sex" => -1}
    when "4"
      {"data.age" => 1}
    when "5"
      {"data.age" => -1}
    else
      {}
    end
    sort.merge!(sel)
    sort.merge!({_id:  -1})
    @rekognitions = paginate3('Rekognition',params[:page], hash, sort,100 )
  end
 
end
