# encoding: utf-8
class AdminUserReportsController < ApplicationController
  include Paginate
  before_filter :admin_authorize
  layout "admin"

  def index
    hash, sort ={:flag => nil} , {}

    @shop_reports = paginate3('shop_report', params[:page], hash, sort)
  end

  def show
    @shop_report = ShopReport.find(params[:id])
    @shop = @shop_report.shop
  end


  def update
    @shop = Shop.find(params[:id])
    shop = Shop.new(params[:shop])
    if shop.lob.blank?
      shop.lob = @shop.lo_to_lob.reverse.join(',')
    else
      lobs = shop.lob.split(/[;；]/)
      @shop.lob = lobs.inject([]){|f,s| f << s.split(/[,，]/).map { |m| m.to_f  }.reverse}
      @shop.lo = @shop.lob.map{|m| Shop.lob_to_lo(m)}
      @shop.unset(:lob)
      
    end

    unless params[:shop][:addr].blank?
      info = @shop.info || ShopInfo.new()
      info._id = @shop.id
      info.addr = params[:shop][:addr]
      info.save
    end

    @shop.name = shop.name
    @shop.t = shop.t
    if @shop.save
      ShopReport.where({:sid => params[:id].to_i, :flag => nil}).each do |report|
        report.update_attribute(:flag, 3)
      end
      @shop = Shop.find_primary(@shop._id)
      render :json => {'name' => @shop.name, 'lo' => @shop.lo, 'addr' => @shop.addr, 'lob' => shop.lob, 'st' => @shop.show_t}
    else
      render :action => :edit
    end

  end

  def send_chat
    Xmpp.send_chat($dduid, params[:to_uid], params[:text])
    render :text => "消息已发送"
  end

  def ajax_del
    shop = Shop.find(params[:sid])
    shop.shop_del
    ShopReport.where({:sid => params[:sid].to_i, :flag => nil}).each do |report|
      report.update_attribute(:flag, 1)
    end
    render :json => ''
  end

  def ajax_distort
    ShopReport.where({:sid => params[:sid].to_i, :flag => nil}).each do |report|
      report.update_attribute(:flag, 2)
    end
    render :json => ''
  end

  
end