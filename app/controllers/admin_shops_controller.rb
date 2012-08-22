class AdminShopsController < ApplicationController

  before_filter :admin_authorize
  layout "admin"

  def index
    @page = params[:page].to_i
    @pcount = params[:pcount].to_i
    @page = 1 if @page==0
    @pcount = 200 if @pcount==0
    skip = (@page - 1)*@pcount
    hash = {}
    lo = [params[:lat].to_f , params[:lng].to_f] if !params[:lat].blank? && !params[:lng].blank?
    hash.merge!({ lo: { "$within" => { "$center" => [lo, 0.1]} }}) if loc
    hash.merge!( {name: /#{params[:name]}/ }  )  if params[:name]
    hash.merge!( {t: params[:t].to_i }  )  if !params[:t].blank?
    hash.merge!( {level: params[:level]}) if !params[:level].blank?
    hash.merge!({city: params[:city]}) if !params[:city].blank?

    @shops_len = Shop.where(hash).length
    @last_page = (@shops_len+@pcount-1)/@pcount


    @shops = Shop.where(hash).skip(skip).limit(@pcount).sort(horder)
    @shops = @shops.entries.keep_if{|s| s.del != 1}
  end


  def ajaxupdatelevel
    shop = Shop.where({_id: params[:shop_id]}).first
    shop.update_attribute(:level, params[:level])
    render :json => {level: shop.reload.level}
  end

  def ajaxdel
    shop = Shop.where({_id: params[:shop_id]}).first
    shop.shop_del
    render :js => true
  end

  private

  def horder
    case params[:order].to_s
    when ''
      {_id: -1}
    when '1'
      {_id: 1}
    when '2'
      {level: -1}
    when '3'
      {level: 1}
    end
  end
  

end
