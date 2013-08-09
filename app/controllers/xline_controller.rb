# coding: utf-8
class XlineController < ApplicationController

  def create
    errmsg = blank_check(:id, :data)
    return render :json => {error: errmsg} if errmsg
    return render :json => {error: "id已有"} if Line.find_by_id(params[:id])
    data = params[:data]
    begin
      arr = []
      data['arr'].each do |m|
        return :json => {error: "找不到id#{m['shopid']}的合作商家"}  unless (shop = Shop.find_by_tid(m['shopid'].to_i))
        time,time2 = m['time'].split('-')
        arr += [{sid: shop.id, lo: shop.lo, time:  time, time2: time2}]
      end
    rescue
      return  render :json => {error: 'data数据格式错误'}
    end
    line = Line.new(name: data['name'],admin_sid:21834762, arr: arr)
    line.id = params[:id]
    line.save
    render :json => {ok: line.id}
  end


  def find
    return render :json => {error: "id必填"} if params[:id].blank?
    line = Line.find_by_id(params[:id])
    if line
      render :json => {data: line.safe_out}
    else
     render :json => {error: ""}
    end
  end


  def blank_check(*arr)
    arr.each{|a| return "#{a.to_s}必填" if params[a].blank?}
    return nil
  end

end
