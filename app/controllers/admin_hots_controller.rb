class AdminHotsController < ApplicationController
  include Paginate
  before_filter :admin_authorize
  layout "admin"

  def index

		today_date = Date.yesterday
		Hot.where(dead_line: today_date).delete_all

    hash = {}

    hash.merge!({shop_id: params[:shop_id]}) unless params[:shop_id].blank?
    hash.merge!({dead_line: params[:dead_line]}) unless params[:dead_line].blank? 
    hash.merge!({shop_rank: params[:shop_rank]}) unless params[:shop_rank].blank?
    hash.merge!({display_range: params[:display_range]}) unless params[:display_range].blank?

    hash.merge!({_id: params[:id].to_i}) unless params[:id].blank?

		logger.info "#{params[:dead_line]}"

    sort = {shop_rank: 1}
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
    os = Hot.new(params[:hot])

    @hot.dead_line = os.dead_line
    @hot.shop_rank = os.shop_rank
    @hot.display_range = os.display_range
    #商家编辑不能编辑城市

    @hot.save

    redirect_to :action => "index"
  end

  def create
		@shop = Shop.find(params[:hot][:shop_id])
		params[:hot][:dead_line] = Date.civil(params[:hot][:"date_array(1i)"].to_i,params[:hot][:"date_array(2i)"].to_i,params[:hot][:"date_array(3i)"].to_i)
		@hot = Hot.create!(params[:hot])
    if @hot.save
      redirect_to :action => "index"
    else
      flash.now[:notice] = "添加热点商家失败."
      render :action => 'new'
    end
  end


  private

  def is_dead_line?(dead_line_date)
		dead_line_date < DateTime.now
	end

  def horder
    case params[:order].to_s
    when ''
      {_id: -1}
    when '1'
      {_id: 1}
    end
  end
end
