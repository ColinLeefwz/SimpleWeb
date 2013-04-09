class AdminBlacksController < ApplicationController
  include Paginate
  before_filter :admin_authorize
  layout "admin"

  def index
    hash = {:report => 1}
    case params[:flag].to_s
    when ''
      hash.merge!(:flag => false)
    when '1'
      hash.merge!(:flag => true)
    end
    sort = {:_id => -1}
    @user_blacks = paginate3('UserBlack', params[:page], hash, sort)
  end

  def ignore
    @user_black = UserBlack.find(params[:id])
    @user_black.update_attribute(:flag, true)
    render :json => {}
  end
end
