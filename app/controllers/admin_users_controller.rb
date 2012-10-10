class AdminUsersController < ApplicationController
  include Paginate
  before_filter :admin_authorize
  layout "admin"

  def index

    hash = {}
    sort = {}

    unless params[:name].blank?
      hash.merge!(name: /#{params[:name]}/)
    end

    @users =  paginate("User", params[:page], hash, sort)


  end

  def show
    @user = User.find(params[:id])
  end

end

