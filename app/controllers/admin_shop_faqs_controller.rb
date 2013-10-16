class AdminShopFaqsController < ApplicationController
  include Paginate
  before_filter :admin_authorize
  layout "admin"

  def index
    hash, sort={sid: {"$ne" => nil}},{:_id => -1}
    unless params[:shop].blank? && params[:city].blank?
      sids = Shop.where({name: /#{params[:shop]}/, city: params[:city]}).map { |m| m._id  }
      hash.merge!(sid: {'$in' => sids})
    end
    hash.merge!({sid: params[:sid].to_i}) unless params[:sid].blank?
    @shop_faqs = paginate3('ShopFaqs', params[:page], hash, sort)
  end

  def ajax_del
    faq = ShopFaq.find(params[:id])
    faq.delete
    render :json => ''
  end
end