class WebChannelSearchController < ApplicationController
  include Paginate
  
  def index

    hash = {}
    sort = {_id: -1}

    hash.merge!({v: params[:v]}) unless params[:v].blank?

    # @channel =  paginate3("Channel", params[:page], hash, sort, 3).group_by{|g| g.v}

    @channel_ip = Channel.where(hash).group_by{|g| g.ip}.map{|k,v| [k,v.count]}
    @channel_date = Channel.where(hash).group_by{|g| g.time.strftime("%Y-%m-%d")}.map{|k,v| [k,v.count]}
    respond_to do |format|
      format.html
    end
  end

end