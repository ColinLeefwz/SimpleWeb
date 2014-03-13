class Photo2sController < ApplicationController
  before_filter :user_login_filter

  def create
    p = Photo2.new(params[:photo])
    p.user_id = session[:user_id]
    p.save!
    render :json => p.output_hash.to_json
  end
  
  def forward
    id = params[:id]
    id = id[1..24] if id[0]=="U"
    p = Photo2.find_by_id(id)
    if p.nil?
      render :json => {error: "被转发的图片被删除或者不存在"}.to_json
      return
    end
    mid = params[:user_id]+p.id
    Resque.enqueue(XmppMsg, params[:user_id], params[:to_uid], "[img:U#{p.id}]", mid)
    #TODO: 确认params[:to_uid]是好友
    render :json => {mid: mid}.to_json
  end
  
  def show
    if params[:id][0]=="U"
      id = params[:id][1..24]
      if params[:size].to_i==0
        redirect_to Photo2.img_url(id)
      else
        redirect_to Photo2.img_url(id,:t2)
      end
    elsif params[:id][0,4]=="Logo"
        id = params[:id][4..27]
        logger.warn "logo id:#{id}"
        if params[:size].to_i==0
          redirect_to UserLogo.img_url(id)
        else
          redirect_to UserLogo.img_url(id,:t2)
        end
    else
      if params[:size].to_i==0
        redirect_to Photo.img_url(params[:id])
      else
        redirect_to Photo.img_url(params[:id],:t2)
      end
    end
  end

end
