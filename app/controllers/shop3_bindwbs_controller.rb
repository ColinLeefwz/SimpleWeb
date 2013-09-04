# coding: utf-8

class Shop3BindwbsController < ApplicationController
  before_filter :shop_authorize
  layout 'shop3'

  def index
    @bind_wb = BindWb.find_by_id(session[:shop_id]) || BindWb.new
  end

  def create
    @bind_wb = BindWb.new(params[:bind_wb])
    @bind_wb._id = session[:shop_id]

    if (error = @bind_wb.check_wb)
      flash.now[:notice] = error
      return  render :action => 'index'
    end
    
    if @bind_wb.save
      redirect_to :action => "index"
    else
      flash.now[:notice] == '绑定失败,请检查微博uid和昵称的正确性.'
    end
  end

  def del
    @bind_wb = BindWb.find(session[:shop_id].to_i)
    Rails.cache.delete("BindWb#{@bind_wb.id.to_i}")
    @bind_wb.delete
    redirect_to :action => "index"
  end

end