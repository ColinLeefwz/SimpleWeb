class Shop3NoticeController < ApplicationController
  before_filter :shop_authorize
  include Paginate
  layout 'shop3'
  
  def index
    @shop_notice = session_shop.notice
    return if @shop_notice.nil?
    return redirect_to :action => :text unless @shop_notice.title.blank?
    return redirect_to :action => :photo if @shop_notice.photo
    return redirect_to :action => :faqs if @shop_notice.faq
  end

  def ajax_release
    shop_notice = ShopNotice.find_or_new(session[:shop_id])
    shop_notice.title = params[:title]
    shop_notice.save
    render :json => {:title => shop_notice.title, :id => shop_notice.id }
  end

  def text
    @shop_notice = session_shop.notice
  end

  def faqs
    @shop_notice = session_shop.notice
    @shop_faqs = session_shop.faqs
  end

  def photo
    @shop_notice = session_shop.notice
    hash = {:room => session[:shop_id].to_i.to_s, :user_id => "s#{session[:shop_id]}" }
    sort = {:od => -1, :updated_at =>  -1}
    @photos = paginate("Photo", params[:page], hash, sort,20)
  end


  def update
    shop_notice = ShopNotice.find_or_new(session[:shop_id])
    shop_notice.update_attributes(params.keep_if{|k,v| k.in?(['title', 'photo_id', 'faq_id'])})
    redirect_to :action => "index"
  end

  def del
    shop_notice = ShopNotice.find_or_new(session[:shop_id])
    shop_notice.destroy
    redirect_to :action => "index"
  end

end
