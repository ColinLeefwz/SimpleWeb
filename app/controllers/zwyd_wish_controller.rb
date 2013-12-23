# coding: utf-8

class ZwydWishController < ApplicationController

  before_filter :photo_authorize, :except => [:list]
  def create
    @zwyd_wish.total += 1
    @zwyd_wish.data << [params[:name], params[:wish]]
    @zwyd_wish.save
    url = "http://dface.cn/zwyd_wish?id=#{params[:id]}"
    Resque.enqueue(XmppMsg, $gfuid, @zwyd_wish.photo.user_id,
      ": 你收到一条来自#{[params[:name]}的祝福，赶快点我看看吧 #{url}")
    return render :json => 1
  end

  def ajax_wish
    data = @zwyd_wish.data
    data = data[0, params[:total].to_i].reverse
    render :json => data[params[:skip].to_i, 10].map{|m| m.join(': ')}.to_json
  end


  def list
    if params[:order] == 'amount'
      sort = {total: -1}
    else
      sort = {_id: -1}
    end
    if params[:skip]
     zwyd_wishs = ZwydWish.where({}).limit(params[:limit]).skip(params[:skip]).sort(sort)
     data = zwyd_wishs.map{|m| ["photo_url" => "http://www.dface.cn/tzw#{m.id}.jpg", 'user_logo' => m.user_logo, 'user_name' => m.photo_user.try(:name), 'photo_desc' => m.photo_desc, 'total' => m.total.to_i, 'wish' => "/zwyd_wish?id=#{m.id}" ]}
    end
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: data.to_json }
    end
  end

  private
  def photo_authorize
    @zwyd_wish = ZwydWish.find_by_id(params[:id])
    return render :text => "无效图片" if @zwyd_wish.nil?
  end


end

