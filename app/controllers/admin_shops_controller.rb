# encoding: utf-8
class AdminShopsController < ApplicationController
  include Paginate
  
  before_filter :admin_authorize
  layout "admin"

  def index

    hash,lo = {},nil
    lo = [params[:lat].to_f , params[:lng].to_f] if !params[:lat].blank? && !params[:lng].blank?
    hash.merge!({ lo: { "$within" => { "$center" => [lo, 0.1]} }}) if lo
    hash.merge!( {name: /#{params[:name]}/ }  )  unless params[:name].blank?
    hash.merge!( {t: params[:t].to_i }  )  unless params[:t].blank?
    hash.merge!({city: params[:city]}) unless params[:city].blank?
    hash.merge!({type: params[:type]}) unless params[:type].blank?

    case params[:v]
    when '1'
      hash.merge!({v:{'$exists' => true}})
    when '2'
      hash.merge!({v:{'$exists' => false}})
    end

    case params[:d]
    when '1'
      hash.merge!({d:{'$exists' => true}})
    when '2'
      hash.merge!({d:{'$exists' => false}})
    end

    case params[:del]
    when '0'
    when '1'
      hash.merge!({del:{'$exists' => true}})
    else
      hash.merge!({del:{'$exists' => false}})
    end

    @page =  params[:page].blank? ? 1 : params[:page].to_i
    @shops = Shop.where(hash).skip((@page-1)*200).limit(200).sort(horder)

  end

  def new
    @shop = Shop.new
  end

  def set_password
    @shop = Shop.find(params[:id])
    if request.post?
      @shop.update_attributes(params[:shop])
      redirect_to :action => "show", :id => @shop.id
    end
  end

  def create
    @shop = Shop.new(params[:shop])
    @shop._id = Shop.next_id
    @shop.lob = @shop.lob.split(/[,，]/).map { |m| m.to_f  }.reverse
    @shop.lo = @shop.lob_to_lo
    @shop.city = @shop.get_city
    @shop.t = @shop.t.to_i
    if @shop.save
      redirect_to :action => "show", :id => @shop.id
    else
      render flash.now[:notice] = "添加商家失败."
    end
  end

  def subshops
    @shop = Shop.find(params[:shop_id])
    @shops = Shop.where({_id: {"$in" => @shop.shops.to_a}}).to_a
    @shops = paginate_arr(@shops, params[:page])
  end

  def show
    @shop = Shop.find(params[:id])
  end

  def near
    @shop = Shop.find(params[:id])
    if ENV["RAILS_ENV"] == "production"
      @shops = Shop.where({:lo => {"$within" => {"$center" => [@shop.loc_first, 0.01]}}})
    else
      @shops = Shop.where({}).limit(5)
    end
    @shops -= [@shop]
    @shops = @shops.map{|shop| [shop._id.to_i, shop.name, shop.addr, ENV["RAILS_ENV"] == "production" ? shop.get_distance(shop.loc_first, @shop.loc_first) : '', shop.show_t]}
    @shops = @shops.sort { |a, b| a[3] <=> b[3] }[0,300]
    #    @shops = Shop.all.to_a
    
  end

  def find_shops
    @shop = Shop.find(params[:pid])
    hash,sort = {},{}

    unless params[:loc].blank?
      lo = params[:loc].split(',')
      hash.merge!({ lo: { "$within" => { "$center" => [lo, 0.1]} }}) if lo.length == 2
    end

    unless params[:shop].blank? && params[:city].blank?
      hash.merge!({name: /#{params[:shop]}/, city: params[:city]})
    end

    unless params[:addr].blank?
      hash.merge!({addr: /#{params[:addr]}/})
    end

    if hash.empty?
      @shops = []
    else
      @shops = Shop.where(hash)
      @shops -= [@shop]
    end
    
  end

  def bat_add_sub
    @shop = Shop.find(params[:pid])
    css = params['shop_ids'].to_a.map{|m| m.to_i}
    ids = params['ids'].to_a.map{|m| m.to_i}
    ucs = ids - css
    @shop.shops = (@shop.shops.to_a - ucs) | css
    @shop.save
    @shop.merge_subshops_locations
    redirect_to "/admin_shops/subshops?shop_id=#{@shop.id}"
  end

  def ajax_find_shop
    pshop = Shop.find_by_id(params[:pid])
    shop = Shop.find_by_id(params[:id])
    text = "<tr><td><input type='text' value=#{params[:id]} onchange='ajaxFindShop($(this))'/></td>"
    if shop
      if pshop.shops.to_a.include?(shop.id.to_i)
        text += "<td colspan='5'>该商家已是#{pshop.name}的子商家。</td><td><a onclick='cancel($(this))'>取消</a></td></tr>"
      else
        text += "<td>#{shop.name}</td>"
        text += "<td>#{shop.tel}</td>"
        text += "<td>#{shop.city}</td>"
        text += "<td>#{shop.addr}</td>"
        text += "<td>#{shop.show_t}</td>"
        text += "<td><input type='submit' value='确定' onclick='ajaxAddSub($(this), \"#{shop.id}\", \"#{params[:pid]}\")' />    <a onclick='cancel($(this))'>取消</a></td></tr>"
      end
    else
      text += "<td colspan='5'>商家id(#{params[:id]})不存在</td><td><a onclick='cancel($(this))'>取消</a></td></tr>"
    end
    render :json => {text: text}
  end

  def ajax_add_sub
    pshop = Shop.find_by_id(params[:pid])
    shop = Shop.find_by_id(params[:id])
    if shop.id == pshop.id
      text = '不能添加。'
    else
      pshop.shops = pshop.shops.to_a << shop.id.to_i
      pshop.save
      pshop.merge_subshops_locations
      text = "<tr><td>#{shop.id.to_i}</td>"
      text += "<td>#{shop.name}</td>"
      text += "<td>#{shop.tel}</td>"
      text += "<td>#{shop.city}</td>"
      text += "<td>#{shop.addr}</td>"
      text += "<td>#{shop.show_t}</td>"
      text += "<td><a onclick='ajaxDelSub($(this),\"#{shop.id}\", \"#{pshop.id}\")'>移除</a></td></tr>"
    end
    render :json => {text: text}
  end

  def ajax_del_sub
    pshop = Shop.find_by_id(params[:pid])
    shop = Shop.find_by_id(params[:id])
    pshop.shops.to_a.delete(shop.id.to_i)
    pshop.save
    pshop.merge_subshops_locations
    render :js => true
  end



  def ajaxdel
    shop = Shop.where({_id: params[:shop_id]}).first
    shop.shop_del
    render :js => true
  end

  def gchat
    @shop = Shop.find(params[:sid])
    @gchats = paginate_arr(@shop.gchat, params[:page], 50)
  end

  def upgrade_v
    @shop = Shop.find(params[:id])
    if request.post?
      @shop.update_attributes(params[:shop])
      redirect_to :action => "show", :id => @shop.id
    end
  end

  def set_v
    
  end
  

  private

  def horder
    case params[:order].to_s
    when ''
      {_id: -1}
    when '1'
      {_id: 1}
    end
  end
  

end
