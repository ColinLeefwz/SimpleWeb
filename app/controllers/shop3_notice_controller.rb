

class Shop3NoticeController < ApplicationController
  before_filter :shop_authorize
  include Paginate
  layout 'shop3'
  
  def index
    @shop_notice = session_shop.notice

    ShopNotice.where({}).sort({_id: -1}).each do |sn|
      begin
        nsn = ShopNotice.new()
        nsn._id = sn.shop_id
        nsn.title = sn.title
        nsn.save
      rescue
        next
      end
    end

  end

  def ajax_release
    shop_notice = ShopNotice.find_or_new(session[:shop_id])
    shop_notice.title = params[:title]
    shop_notice.save
    render :json => {:title => shop_notice.title, :id => shop_notice.id }
  end

  def faqs
    @shop_faqs = session_shop.faqs
  end

  def from_faq
    faq = ShopFaq.find_by_id(params[:id])
    if faq
      shop_notice = ShopNotice.find_or_new(session[:shop_id])
      shop_notice.faq_id = faq.id
      shop_notice.save
    end
    redirect_to :action => "index"
  end

  def edit
    hash = {:room => session[:shop_id].to_i.to_s, :user_id => "s#{session[:shop_id]}" }
    sort = {:od => -1, :updated_at =>  -1}
    @photos = paginate("Photo", params[:page], hash, sort,20)
  end

  def update
    photo = Photo.find_by_id(params[:id])
    if photo
      shop_notice = ShopNotice.find_or_new(session[:shop_id])
      shop_notice.photo_id = photo.id
      shop_notice.save
    end
    redirect_to :action => "index"
  end

  def del
    shop_notice = ShopNotice.find_or_new(session[:shop_id])
    shop_notice.destroy
    redirect_to :action => "index"
  end

end
