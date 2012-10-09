class AdminShopsController < ApplicationController
  include Paginate
  
  before_filter :admin_authorize
  layout "admin"

  def index

    hash,lo = {},nil
    lo = [params[:lat].to_f , params[:lng].to_f] if !params[:lat].blank? && !params[:lng].blank?
    hash.merge!({ lo: { "$within" => { "$center" => [lo, 0.1]} }}) if lo
    hash.merge!( {name: /#{params[:name]}/ }  )  if params[:name]
    hash.merge!( {t: params[:t].to_i }  )  if !params[:t].blank?
    hash.merge!({city: params[:city]}) if !params[:city].blank?

    @shops = paginate("Shop", params[:page], hash, horder, 200  )
    @shops = @shops.entries.keep_if{|s| s.del != 1}


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
    end
  end
  

end
