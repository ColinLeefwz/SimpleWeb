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

  def edit
    @shop_faq = ShopFaq.find(params[:id])
  end

  def update
    @shop_faq = ShopFaq.find(params[:id])
    if @shop_faq.update_attributes(params[:shop_faq])
      redirect_to :action => "show", :id => @shop_faq.id
    else
      render :action => :edit
    end
  end

  def show
    @shop_faq = ShopFaq.find_primary(params[:id])
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
    text = (@shop_faq.destroy ? '删除成功.' : nil)
    render :json => {text: text}
  end


end
