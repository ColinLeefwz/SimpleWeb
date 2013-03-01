# coding: utf-8

class ShopFaqsController < ApplicationController
  before_filter :shop_authorize
  layout 'shop'

  def index
    @shop_faqs = session_shop.faqs
  end
  
  def new
    @shop_faq = ShopFaq.new
  end

  def create
    @shop_faq = ShopFaq.new(params[:shop_faq])
    @shop_faq.sid = session[:shop_id]

    if @shop_faq.save
      redirect_to :action => "index"
    else
      render :action => :new
    end
  end

  def ajax_del
    @shop_faq = ShopFaq.find(params[:id])
    text = (@shop_faq.delete ? '删除成功.' : nil)
    render :json => {text: text}
  end


end
