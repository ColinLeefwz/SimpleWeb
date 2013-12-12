# encoding: utf-8
class AdminGuestController < ApplicationController
  include Paginate
  before_filter :admin_authorize
  layout "admin"

  def index
    hash = {}
    sort = {_id: -1}
    @guests =  paginate3("Guest", params[:page], hash, sort)
  end


  def new
    @guest = Guest.new
  end

  def create
    guest = Guest.new(params[:guest])
    if guest.save
      redirect_to :action => :index
    else
      render :action => :new
    end
  end

  def delete
    guest = Guest.find_by_id(params[:id])
    guest.delete
    redirect_to :action => :index
  end

  def ds_stat
    hash ={}
    sort= {_id: -1}
    @ds_stats = paginate3("UserDsStat", params[:page], hash, sort)
  end


end