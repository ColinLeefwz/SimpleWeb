class ShopCheckinAltsController < ApplicationController
  include Paginate
  before_filter :admin_authorize
  layout "admin"

  def index
    hash = {}
    sort = {_id: -1}
    @shop_checkin_alts = paginate3("CheckinShopAlt", params[:page], hash, sort)
  end

  def shops
    @checkin_shop_alt = CheckinShopAlt.find(params[:id])
    @hshops = paginate_arr(@checkin_shop_alt.datas.to_a, params[:page])
  end
end

