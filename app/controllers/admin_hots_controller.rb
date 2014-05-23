class AdminHotsController < ApplicationController
  include Paginate
  before_filter :admin_authorize
  layout "admin"

  def index
		
		remove_overdue

    hash = {}

    hash.merge!({shop_id: params[:shop_id]}) unless params[:shop_id].blank?
    hash.merge!({dead_line: params[:dead_line]}) unless params[:dead_line].blank? 
    hash.merge!({od: params[:od]}) unless params[:od].blank?
    hash.merge!({display_range: params[:display_range]}) unless params[:display_range].blank?

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

		@hot.shop_id = os.shop_id
    @hot.dead_line = os.dead_line
    @hot.od = os.od
    @hot.display_range = os.display_range
    #商家编辑不能编辑城市

    @hot.save

    redirect_to :action => "index"
  end

  def create
		@shop = Shop.find(params[:hot][:shop_id])
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
