# coding: utf-8

class Shop3FaqsController < ApplicationController
  before_filter :shop_authorize, :except => [:show]
  layout 'shop3'

  def index
    @shop_faqs = session_shop.faqs
  end
  
  def new
    @shop_faq = ShopFaq.new
    # @shop_faq.save!
    @shop_faqs = session_shop.faqs
  end

  def edit
    @shop_faqs = session_shop.faqs
    @shop_faq = ShopFaq.find(params[:id])
  end

  def update
    @shop_faq = ShopFaq.find(params[:id])
    if params[:shop_faq][:img]
      faq = ShopFaq.new(params[:shop_faq])
      faq.sid = session[:shop_id]
      faq.save
      @shop_faq.delete
      return  redirect_to :action => "index"
    end

    if @shop_faq.update_attributes(params[:shop_faq])
      redirect_to :action => "index"
    else
      render :action => :edit
    end
  end

  def show
    sf = ShopFaq.find_primary(params[:id])
    @shop_faq = sf
    @shop = Shop.find_by_id(sf.sid)
    render :layout => false
  end

  def preview
    @shop_faq = ShopFaq.find_primary(params[:id])
    render :layout => false
  end

  def create
    @shop_faq = ShopFaq.new(params[:shop_faq])
    @shop_faq.sid = session[:shop_id]

    if @shop_faq.save
      $redis.sadd("FaqS#{session_shop.city}", session_shop.id)
      redirect_to :action => "index"
    else
      render :action => :new
    end
  end

  #异步预览，预览一次数据库会生成一次sid：nil的记录，用户看不到，得定期清理 TODO
  def ajax_preview
    @shop_faq = ShopFaq.new
    @shop_faq.od = params[:od]
    @shop_faq.title = params[:title]
    @shop_faq.text = params[:text]
    @shop_faq.head = params[:head]
    @shop_faq.content = params[:content]
    @shop_faq.save!
    
    render :json => {id: @shop_faq.id}
  end

  def ajax_del
    @shop_faq = ShopFaq.find(params[:id])
    text = (@shop_faq.destroy ? '删除成功.' : nil)
    $redis.srem("FaqS#{session_shop.city}", session_shop.id) if session_shop.no_faq?
    render :json => {text: text}
  end

  def article_image_upload
    image = Image.new
    image.article_id = params[:id]
    image.img = params[:upfile]
    image.save!
    render :json=>{:url => image.img.url, 'state'=>'SUCCESS', :title=>params[:pictitle]}  
  end

end
