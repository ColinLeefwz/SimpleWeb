# encoding: utf-8
class AdminBranchsController < ApplicationController
  include Paginate
  
  before_filter :admin_authorize
  layout "admin"

  def index
    @pshop = Shop.find(params[:psid].to_i)
    hash, sort = {:psid => @pshop.id.to_i},{}
    @shops = paginate3("Shop", params[:page], hash, sort, 50)
  end


  def ajax_add_branch
    @shop = Shop.find(params[:id].to_i)
    if @shop.psid
      text = "该商家已是id'#{@shop.psid}'的分店."
    elsif @shop.id.to_i == params[:psid].to_i
      text = "不能添加本身为分店."
    else
      @shop.psid = params[:psid].to_i
      text = @shop.save ? '添加成功' : '添加失败'
    end
    render :json => {:text => text}
    
  end

  def ajax_del_branch
    @shop = Shop.find(params[:id].to_i)
    @shop.unset(:psid)
    render :json => ''
  end

  def find_shops
    @pshop = Shop.find(params[:psid].to_i)
   
    if !params[:city].blank? && !params[:name].blank?
      hash = {del: {"$exists" => false}}
      if params[:fun] == 'true'
        hash.merge!({:city => params[:city], :name => params[:name]})
      else
        hash.merge!({:city => params[:city], :name => /#{params[:name]}/})
      end
      @shops = Shop.where(hash).limit(300).reject{|s| (s.psid && s.psid.to_i != params[:psid].to_i) || s.id.to_i == @pshop.id.to_i}
    else
      @shops = []
    end
    
  end

  def bat_add_sub
    cancel = params[:ids].to_a - params[:shop_ids].to_a
    check = params[:shop_ids].to_a - params[:ids].to_a
    cancel.each{|c| Shop.find(c.to_i).unset(:psid)}
    check.each{|c| Shop.find(c.to_i).update_attribute(:psid, params[:psid].to_i)}
    redirect_to :action => "index", :psid => params[:psid]
  end

  

end
