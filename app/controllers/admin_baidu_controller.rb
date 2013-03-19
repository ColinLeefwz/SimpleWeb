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
end

