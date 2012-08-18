class AdminShopsController < ApplicationController

  before_filter :admin_authorize
  layout "admin"

  def index
    @page = params[:page].to_i
    @pcount = params[:pcount].to_i
    @page = 1 if @page==0
    @pcount = 15 if @pcount==0
    skip = (@page - 1)*@pcount
    loc = Offset.offset(params[:lat].to_f , params[:lng].to_f) if false
    hash = {}
    hash.merge!( loc: { "$within" => { "$center" => [loc, 0.1]} }) if loc
    hash.merge!( {name: /#{params[:name]}/ }  )  if params[:name]
    hash.merge!( {t: params[:t].to_i }  )  if !params[:t].blank?
    hash.merge!({city: params[:city]}) if !params[:city].blank?
    @shops_len = Shop.where(hash).length
    @last_page = (@shops_len+@pcount-1)/@pcount
    @shops = Shop.where(hash).skip(skip).limit(@pcount)
  end
  

end
