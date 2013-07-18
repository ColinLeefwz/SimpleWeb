class WebUserSearchController < ApplicationController
  include Paginate
  
  def index

    hash = {}
    sort = {_id: -1}

    hash.merge!({id: params[:id]}) unless params[:id].blank?

    @users =  paginate3("User", params[:page], hash, sort, 1)
  end

end