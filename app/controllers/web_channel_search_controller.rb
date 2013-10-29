class WebChannelSearchController < ApplicationController
  include Paginate
  
  def index

    hash = {}
    sort = {_id: -1}

    hash.merge!({v: params[:v]}) unless params[:v].blank?
    @channel_dip = Channel.where(hash).group_by{|g| [g.time.strftime("%Y-%m-%d"),g.ip]}.map{|k,v| [k,v.count]}
    @channel_ip = Channel.where(hash).group_by{|g| g.ip}.map{|k,v| [k,v.count]}
    @channel_date = Channel.where(hash).group_by{|g| g.time.strftime("%Y-%m-%d")}.map{|k,v| [k,v.count]}
    respond_to do |format|
      format.html
    end
  end

end