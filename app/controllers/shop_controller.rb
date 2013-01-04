class ShopController < ApplicationController

  layout nil
  
  def nearby
    page = params[:page].to_i
    pcount = params[:pcount].to_i
    page = 1 if page==0
    pcount = 20 if pcount==0
    skip = (page-1)*pcount
    lo = [params[:lat].to_f , params[:lng].to_f]
    hash = {lo:{"$within"=>{"$center"=> [lo,0.05]}}}
    if params[:name]
      hash.merge!( {name: /#{params[:name]}/ }  )  
    else
      hash.merge!( {utotal:{"$gt" => 0}, t:{"$exists"=>true}, del:{"$exists"=>false} }  )  
    end
    if params[:type]
      t = params[:type].to_i*2-1
      hash.merge!( {t: { "$in" => [ t-1, t ] } }  ) 
    end
    shops = Shop.where(hash).sort({utotal:-1}).skip(skip).limit(pcount)
    render :json =>  shops.map {|s| s.safe_output_with_users}.to_json
  end
  
  def users
    shop = Shop.find(params[:id])
    page = params[:page].to_i
    pcount = params[:pcount].to_i
    page = 1 if page==0
    pcount = 20 if pcount==0
    render :json => shop.users(session[:user_id],(page-1)*pcount,pcount).to_json
  end
  
  def info
    shop = Shop.find(params[:id])
    render :json => shop.safe_output_with_staffs.to_json
  end


end
