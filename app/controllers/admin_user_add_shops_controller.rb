# encoding: utf-8
class AdminUserAddShopsController < ApplicationController
  include Paginate
  before_filter :admin_authorize
  layout "admin"

  def index
    hash = {_id:{"$gt" => 21000000}, creator: {"$ne" => nil}}
   
    case params[:flag]
    when '0'
    when '1'
      hash.merge!({t: {"$gte" => 0}})
    when '2'
      hash.merge!({del: 1})
    when '3'
      hash.merge!({i: true})
    else
      hash.merge!({i: nil})
    end

    hash.merge!( {name: /#{params[:name]}/ }  )  unless params[:name].blank?
    hash.merge!({city: params[:city]}) unless params[:city].blank?
    @shops = paginate3('shop',params[:page], hash,{_id: -1} ,10 )
  end

  def show
    @shop = Shop.find_by_id(params[:id])
    @shop.lob = @shop.lo_to_lob.reverse.join(',')
    render :layout => true
  end

  def ignore
    @shop = Shop.find(params[:id])
    @shop.update_attribute(:i, true)
    respond_to do |format|
      format.html # index.html.erb
      format.json {render :json => ''}
      format.js { render :js => "window.opener.rmshop('#{@shop.id.to_i}');"}
    end
  end

  #  def baidu_map
  #    @shop = Shop.find(params[:id])
  #  end
  #
  #  def edit
  #    @shop = Shop.find(params[:id])
  #  end

  def update
    @shop = Shop.find(params[:id])
    shop = Shop.new(params[:shop])
    unless shop.lob.blank?
      lobs = shop.lob.split(/[;；]/)
      @shop.lob = lobs.inject([]){|f,s| f << s.split(/[,，]/).map { |m| m.to_f  }.reverse}
      @shop.lo = @shop.lob.map{|m| Shop.lob_to_lo(m)}
      @shop.unset(:lob)
    else
      shop.lob = @shop.lo_to_lob.reverse.join(',')
    end

    
    unless params[:shop][:addr].blank?
      info = @shop.info || ShopInfo.new()
      info._id = @shop.id
      info.addr = params[:shop][:addr]
      info.save
    end

    #    @shop.addr = shop.addr
    @shop.name = shop.name
    @shop.t = shop.t
    @shop.i = true
    if @shop.save
      if Lord.assign(@shop.id,@shop.creator)
        Xmpp.send_chat($dduid,@shop.creator,": 您创建的地点#{@shop.name}审核通过。恭喜你成为#{@shop.name}的地主👑")
      end
      
      pshop = Shop.find_by_id(params[:pid])
      if pshop
        pshop.shops = pshop.shops.to_a << @shop.id.to_i unless pshop.shops.to_a.include?(@shop.id.to_i)
        pshop.save
        pshop.merge_subshops_locations
      end
      @shop = Shop.find_primary(@shop._id)
      render :json => {'name' => @shop.name, 'lo' => @shop.lo, 'addr' => @shop.addr, 'lob' => shop.lob, 'st' => @shop.show_t}
    else
      render :action => :edit
    end
    
  end

  def del
    @shop = Shop.find(params[:id])
    @shop.shop_del
    @shop.update_attribute(:i, true)
    render :js => "rmshop('#{@shop.id.to_i}');"
  end

  def ajax_del
    @shop = Shop.find(params[:id])
    @shop.shop_del
    @shop.update_attribute(:i, true)
    render :js => "window.opener.rmshop('#{@shop.id.to_i}');"
  end

  def ajax_dis
    lob1 = params[:lob1].split(/[,，]/).map { |m| m.to_f  }.reverse
    lob2 = params[:lob2].split(/[,，]/).map {|m| m.to_f }.reverse
    distance = Shop.new.get_distance(lob1, lob2)
    render :json => {:distance => distance}
  end

  def post_chat
    Xmpp.send_chat($dduid, params[:to_uid], params[:text])
    render :text => "消息已发送"
  end

  def near
    @shop = Shop.find_by_id(params[:id])
    shops = Shop.similar_shops(@shop, 60)
    data = shops.map{|shop| [ shop.id.to_i, shop.name,  shop.addr,  shop.show_t,  shop.min_distance(shop, @shop.lo)]}
    render :json => data
  end
end