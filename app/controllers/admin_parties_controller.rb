# coding: utf-8
class AdminPartiesController < ApplicationController
  before_filter :admin_authorize
  include Paginate
  layout 'admin'
  def index
    hash = {}
    sort = {_id: -1}
    @parties = paginate('Party', params[:page], hash , sort)
  end

  def new
    @party = Party.new
  end

  def create
    @party = Party.new(params[:party])
    if @party.etime > @party.ftime
      Party.save(@party)
      redirect_to admin_party_path(@party)
    else
      flash.now[:notice] = "结束时间不能早于开始时间"
      render :action => 'new'
    end
  end

  def show
    #    @party = Party.find_primary(params[:id])
    @party = Party.find(params[:id])
  end

  def ajax_delay
    @party = Party.find(params[:id])
    @party.etime = (@party.etime.to_datetime+1.days).strftime('%Y-%m-%d %H:%M')
    @party.save
    render :json => {:text => "延时至#{@party.etime}"}
  end

  def ajax_over
    @party = Party.find(params[:id])
    @party.expire
    render :json => {:text => '已过期'}
  end

end

