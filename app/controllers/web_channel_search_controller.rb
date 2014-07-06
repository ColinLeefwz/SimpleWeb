class WebChannelSearchController < ApplicationController
  include Paginate
  
  def index

    hash = {}
    hash.merge!({v: params[:v]}) unless params[:v].blank?
    if !hash.blank?
      ch = Channel.where(hash)
      @channel_day_uniq_ip = ch.group_by{|g| [g.time.strftime("%Y-%m-%d"),g.ip]}.map{|a,b| [a,b.count]}.group_by{|g| g[0][0]}.map{|a,b| [a,b.count]}
      @channel_dip = ch.group_by{|g| [g.time.strftime("%Y-%m-%d"),g.ip]}.map{|k,v| [k,v.count]}
      @channel_ip = ch.group_by{|g| g.ip}.map{|k,v| [k,v.count]}
      @channel_date = ch.group_by{|g| g.time.strftime("%Y-%m-%d")}.map{|k,v| [k,v.count]}
    else
      @channel_day_uniq_ip = []
      @channel_dip = []
      @channel_ip = []
      @channel_date = []
    end

  end

end