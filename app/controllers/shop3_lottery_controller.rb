# coding: utf-8

class Shop3LotteryController < ApplicationController
  before_filter :shop_authorize, :except => [:game,:ajax_phone]
  layout 'shop3'

  def index
    @lottery = Lottery.all
  end

  def new
    @lottery = Lottery.new
  end

  def create
    @lottery = Lottery.new(params[:lottery])
    @lottery.sid = session_shop.id
    if @lottery.save
      flash[:notice] = "创建成功"
      redirect_to :action => "index"
    else
      flash[:notice] = "创建失败"
      render :action => :new
    end
  end

  def edit
    @lottery = Lottery.find_by_id(params[:id])
  end

  def update
    @lottery = Lottery.find_by_id(params[:id])
    if @lottery.update_attributes(params[:lottery])
      flash[:notice] = "更新成功"
      redirect_to :action => "index"
    else
      flash[:notice] = "更新失败"
      render :action => :edit
    end
  end

  def destroy
    @lottery = Lottery.find_by_id(params[:id])
    if @lottery.destroy
      flash[:notice] = "删除成功"
      redirect_to :action => "index"   
    else
      flash[:notice] = "删除失败"
      redirect_to :action => "index"
    end
  end

  def game
    # num = Game.where({uid:params[:uid],id: {'$gt' => Time.now.beginning_of_day.to_i.to_s(16).ljust(24, '0'),
    #                                   '$lt' => Time.now.end_of_day.to_i.to_s(16).ljust(24, '0')}})
    # if num > 10 

    @lottery = Lottery.find_by_id(params[:id])
    render :layout => false
  end

  def ajax_phone
    game = Game.new
    game.gid = params[:gid]
    game.sid = params[:sid]
    game.uid = params[:uid]
    game.sn = params[:txt]
    game.phone = params[:tel]
    game.save!
    cp = Coupon.find_by_id("5305d4e220f3186569000064")
    cp.send_coupon(params[:uid])
  end

end
