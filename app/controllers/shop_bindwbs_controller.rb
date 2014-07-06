# coding: utf-8

class ShopBindwbsController < ApplicationController
  before_filter :shop_authorize
  layout 'shop'

  def index
    @bind_wb = BindWb.find2(session[:shop_id]) || BindWb.new
  end

  def create
    @bind_wb = BindWb.new(params[:bind_wb])
    @bind_wb._id = session[:shop_id]
    if @bind_wb.save
      redirect_to :action => "index"
    else
       flash.now[:notice] == '绑定失败,请检查微博uid和昵称的正确性.'
       render :action => 'index'
    end
  end

  def del
    @bind_wb = BindWb.find(session[:shop_id])
    @bind_wb.delete
    redirect_to :action => "index"
  end

end
