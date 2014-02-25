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
      redirect_to :action => "index"
    else
      render :action => :new
    end
  end

  def game
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
