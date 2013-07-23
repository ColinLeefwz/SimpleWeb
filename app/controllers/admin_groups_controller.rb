# encoding: utf-8
class AdminGroupsController < ApplicationController
  include Paginate
  before_filter :admin_authorize
  layout "admin"

  def index
    hash = {}
    sort = {_id: -1}
    @groups =  paginate3("Group", params[:page], hash, sort)
  end

  def invaild
    group = Group.find_by_id(params[:id])
    group.invalidate_old
    render :json => {}
  end


end

