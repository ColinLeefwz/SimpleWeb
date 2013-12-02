class WebShopSearchController < ApplicationController
  include Paginate
  
  def index

    if request.post?
      @shops = Shop.where2({name: /#{params[:name]}/, city: params[:city], del: nil})
    else
      @shops=[]
     
    end

  end

end