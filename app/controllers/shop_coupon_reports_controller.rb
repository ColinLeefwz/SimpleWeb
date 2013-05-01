# encoding: utf-8
class ShopCouponReportsController < ApplicationController
  before_filter :shop_authorize
  include Paginate
  layout 'shop'
  require 'iconv'
  require 'csv'


  def index
    cdss = CouponDayStat.where({sid: session[:shop_id]}).only(:_id).unshift('')
    if params[:page].to_i > 1
      coupon_day_stats = paginate_arr(cdss, params[:page], 1)
      coupon_day_stat = CouponDayStat.find_by_id(coupon_day_stats[0])
      @day = coupon_day_stat.day
      @report = coupon_day_stat.data.map{|x,y| [Coupon.find_by_id(x), y[0].to_i, y[1].to_i]}
    else
      coupon_downs = CouponDown.where({sid: session[:shop_id], dat: {"$gte" => Time.now.to_date}}).only(:cid, :uat)
      @report = coupon_downs.group_by{|g| g.coupon}.map{|x,y| [x,y.count, y.count{|c| c.uat}]}
      paginate_arr(cdss, 1, 1)
    end
    
  end

  def csv_export
    content_type = if request.user_agent =~ /windows/i
      'application/vnd.ms-excel;'
    else
      'text/csv;'
    end  

    if params[:stime] && params[:etime]
      hash = {dat: {"$gt" => params[:stime], "$lt" => params[:etime].succ}}
      unless params[:cname].blank?
        cids = Coupon.where({name: params[:cname]}).only(:_id).map{|m| m._id}
        hash.merge!({cid: {'$in' => cids}})
      end
      coupon_downs = CouponDown.where(hash)
    else
      coupon_downs = CouponDown.where({dat: {"$gt" => Time.now.to_date}})
    end

    csv_string =  CSV.generate do |csv|
      csv << ['优惠券名称' , '下载用户',"下载时间","收到时间","查看时间", '使用时间', '分店', '备注']
      coupon_downs.each do |d|
        csv << [d.coupon_name, reject_unident(d.user_name), to_local(d.dat), to_local(d.sat), to_local(d.vat), to_local(d.uat), d.sub_shop_name, d.data]
      end
    end
    send_data( csv_string, :type => content_type, :filename => "exp.csv")
  end

  private
  def reject_unident(str)
    str.gsub(/[^\u4E00-\u9FFF\s\d\w]/, '')
  end

  def to_local(datetime)
    return datetime unless datetime.is_a?(Date)
    datetime.to_time.localtime
  end
end