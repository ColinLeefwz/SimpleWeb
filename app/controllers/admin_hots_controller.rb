class AdminHotsController < ApplicationController
  include Paginate
  before_filter :admin_authorize
  layout "admin"

  def index

    lo, pcount = nil,20
    lo = [params[:lat].to_f , params[:lng].to_f] if !params[:lat].blank? && !params[:lng].blank?
    hash.merge!({ lo: { "$within" => { "$center" => [lo, 0.1]} }}) if lo
		
    page = params[:page].to_i
    pcount = params[:pcount].to_i
    page = 1 if page==0
    pcount = 20 if pcount==0
    skip = (page-1)*pcount
    lo = [params[:lat].to_f,params[:lng].to_f]
    lo = Shop.lob_to_lo(lo) if params[:baidu].to_i==1
    city = Shop.get_city(lo)
    arr = Shop.where({city:city, password:{"$exists" => true}}).skip(skip).limit(pcount)
    if city
      shop = Shop.find_by_id(21838725) # 行酷车友会
      if shop
	      shop.city = city
        arr = arr+[ shop ]
      end
    end
    if city && city=="023"
      shop = Shop.find_by_id(21839246) # 重庆的2014我们在一起
      if shop
	      shop.city = city
        arr = arr+[ shop ]
      end
    end
    if city && city=="023"
      shop = Shop.find_by_id(21838424) # 铜梁安居古城
      if shop
	      shop.city = city
        arr = arr+[ shop ]
      end
    end    
    if city && city=="0571"
      shop = Shop.find_by_id(21831686) # 西溪印象城
      if shop
        arr = arr[0,3]+[ shop ]+arr[3..-1]
      end
    end
    if city && city=="023" && lo[0].to_s[0,4]=="29.8" && lo[1].to_s[0,5]=="106.0" 
      shop = Shop.find_by_id(21839992) # 铜梁脸脸
      if shop
	      shop.city = city
        arr = arr+[ shop ]
      end
    end
    if city && city=="023" && lo[0].to_s[0,4]=="29.3" && ( lo[1].to_s[0,5]=="105.9" || lo[1].to_s[0,5]=="105.8")
      shop = Shop.find_by_id(21840462) # 永川脸脸 [29.348392999999998, 105.913615]
      if shop
	      shop.city = city
        arr = arr+[ shop ]
      end
    end
    arr.uniq!
    ret = arr.find_all{|x| x!=nil}.map do |x|  
      hash = x.safe_output_with_users
      ghash = x.group_hash(session[:user_id])
      #logger.info ghash
      hash.merge!(ghash)
      hash
    end
    coupons = $redis.smembers("ACS#{city}") 
    if coupons
      ret.each_with_index do |xx,i|
        ret[i]["coupon"] = 1 if coupons.index(xx["id"].to_i.to_s)
      end
    end
    # render :json =>  ret.to_json

		remove_overdue

    hash = {}

    hash.merge!({sid: params[:sid]}) unless params[:sid].blank?
    hash.merge!({dead_line: params[:dead_line]}) unless params[:dead_line].blank? 
    hash.merge!({od: params[:od]}) unless params[:od].blank?
    hash.merge!({city: params[:city]}) unless params[:city].blank?

    hash.merge!({_id: params[:id].to_i}) unless params[:id].blank?

		logger.info "#{params[:dead_line]}"

    sort = {od: 1}
    @hots =  paginate3("Hot", params[:page], hash, sort)
  end

  def new
		@hot = Hot.new
  end

  def edit
    @hot = Hot.find(params[:id])
  end

	def delete
    hot = Hot.find(params[:id])
		Del.insert(hot)
		redirect_to :action => "index"
	end

  def update
    @hot = Hot.find(params[:id])
		params[:hot][:dead_line] = Date.civil(params[:hot][:"dead_line(1i)"].to_i,params[:hot][:"dead_line(2i)"].to_i,params[:hot][:"dead_line(3i)"].to_i)
    os = Hot.new(params[:hot])

		@hot.sid = os.sid
    @hot.dead_line = os.dead_line
    @hot.od = os.od
    @hot.city = os.city
    #商家编辑不能编辑城市

    @hot.save

    redirect_to :action => "index"
  end

  def create
		@shop = Shop.find(params[:hot][:sid])
		params[:hot][:dead_line] = Date.civil(params[:hot][:"dead_line(1i)"].to_i,params[:hot][:"dead_line(2i)"].to_i,params[:hot][:"dead_line(3i)"].to_i)
		@hot = Hot.create!(params[:hot])
    if @hot.save
      redirect_to :action => "index"
    else
      flash.now[:notice] = "添加热点商家失败."
      render :action => 'new'
    end
  end

	def remove_overdue
		@hots = Hot.all
		@hots.each do |hot|
      if hot.dead_line < Date.today.to_date 
				Del.insert(hot)
			end
		end
	end

	def check_shop_name

		if Shop.where(id: params[:id]).exists?
			@shop = Shop.find(params[:id])
			render :json => {:name => @shop.name, :status => "success"}
		else
			render :json => {:name => "id错误", :status => "failed"}
		end
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
