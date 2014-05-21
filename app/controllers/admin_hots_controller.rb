class AdminHotsController < ApplicationController
  include Paginate
  before_filter :admin_authorize
  layout "admin"

  def index

    hash,lo, pcount = {},nil,20
    lo = [params[:lat].to_f , params[:lng].to_f] if !params[:lat].blank? && !params[:lng].blank?
    hash.merge!({ lo: { "$within" => { "$center" => [lo, 0.1]} }}) if lo

    hash.merge!({shop_id: params[:shop_id]}) unless params[:shop_id].blank?
    hash.merge!({dead_line: params[:dead_line]}) unless params[:dead_line].blank?
    hash.merge!({shop_rank: params[:shop_rank]}) unless params[:shop_rank].blank?
    hash.merge!({display_range: params[:display_range]}) unless params[:display_range].blank?

    hash.merge!({_id: params[:id].to_i}) unless params[:id].blank?

    sort = {_id: -1}
    @hots =  paginate3("Hot", params[:page], hash, sort)
  end

  def new
		@hot = Hot.new
  end

  def edit
    @hot = Hot.find(params[:id])
  end

  def update
    @hot = Hot.find(params[:id])
    os = Hot.new(params[:hot])

    @hot.dead_line = os.dead_line
    @hot.shop_rank = os.shop_rank
    @hot.display_range = os.display_range
    #商家编辑不能编辑城市

    @hot.save

    redirect_to :action => "index"
  end

  def create
		params[:hot][:dead_line] = Date.civil(params[:hot][:"date_array(1i)"].to_i,params[:hot][:"date_array(2i)"].to_i,params[:hot][:"date_array(3i)"].to_i)
		@hot = Hot.create!(params[:hot])
    if @hot.save
      redirect_to :action => "index"
    else
      flash.now[:notice] = "添加商家失败."
      render :action => 'new'
    end
  end

  def show
    @shop = Shop.find_primary(params[:id])
  end

  def ajax_find_shop
    pshop = Shop.find_by_id(params[:pid])
    shop = Shop.find_by_id(params[:id])
    text = "<tr><td><input type='text' value=#{params[:id]} onchange='ajaxFindShop($(this))'/></td>"
    if shop
      if pshop.shops.to_a.include?(shop.id.to_i)
        text += "<td colspan='6'>该商家已是#{pshop.name}的子商家。</td><td><a onclick='cancel($(this))'>取消</a></td></tr>"
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

  def del
    shop = Shop.find(params[:id])
    return render :text => "合作商家不能删除" if shop.cooperationer?
    shop.shop_del
    redirect_to :action => :index
  end

  def ajaxdel
    shop = Shop.find(params[:shop_id])
    return render :json => {:text => "合作商家不能删除"} if shop.cooperationer?
    shop.shop_del
    render :json => {}
  end

  def ajax_des
    shop = Shop.find(params[:id])
    return render :json => {:text => "合作商家不能删除"} if shop.cooperationer?
    if shop.checkins.limit(1).only(:_id).first
      render :json => {text: "有签到商家不能删除"}
    else
      Del.insert(shop)
      render :json => {}
    end
  end

  def undel
    shop = Shop.find(params[:id])
    shop.unset(:del)
    respond_to do |format|
      format.json {render :json => {:text => "yyy"}}
      format.html {redirect_to :action => :index}
    end 
  end 

  def ajaxunsetlob
    shop = Shop.find(params[:shop_id])
    return render :json => {:text => "合作商家不能取消"} if shop.cooperationer?
    shop.unset(:lo)
    render :json => {}
  end

  def merge_to
    shop= Shop.find(params[:id])
    shop.merge_to(params[:mid])
    redirect_to params[:back_to]
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

	def hot_params
		params.require(:hot).permit(:shop_id, :dead_line, :shop_rank, :display_range)
	end

	def shop_params
		params.require(:hot).permit(:shop_id)
	end
end
