# encoding: utf-8
class AdminChannelsDescController < ApplicationController
  include Paginate
  before_filter :admin_authorize
  layout "admin"

  def index
    hash = {}
    sort = {id: -1}

    unless params[:num].blank?
      hash.merge!({num: params[:num]})
    end

    @channels =  paginate3("ChannelDesc", params[:page], hash, sort)
  end

  def new
    @channel = ChannelDesc.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  def create
    @channel = ChannelDesc.new(params[:channel_desc])

    if @channel.save
      redirect_to :action => "index"
    else
      render :action => "new"
    end
  end

  def destory
    channel = ChannelDesc.find(params[:id])
    channel.delete
    redirect_to :action => "index"
  end
 
  def edit
    @channel = ChannelDesc.find(params[:id])
  end
  
  def update
    @channel = ChannelDesc.find(params[:id])
    @channel.update_attributes(params[:channel_desc])
    redirect_to :action => "index"
  end

  def s
    @channel = ChannelDesc.find(params[:id])
  end

end

