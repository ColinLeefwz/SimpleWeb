# coding: utf-8
class AdminGchatContentReviewController < ApplicationController
  before_filter :admin_authorize
  include Paginate
  layout 'admin'
  
  def index
    hash = "(this.txt.length > 30 && this.txt[0] !='[' && this.del != true) || (this.txt[0] == '[' && this.txt[1] == 'i' && this.txt.length > 60 && this.del != true)"
    sort = {_id: -1}
    @gchat_review =  paginate3("Gchat", params[:page], hash, sort)
    # @gchat_review = Gchat.where("(this.txt.length > 30 && this.txt[0] !='[' && this.del != true) || this.txt[0] == '['").limit(50)
  end

  def ajax_pb
    gchat = Gchat.find_by_id(params[:id])
    gchat.set(:del, true)
    render :json => {}
  end

  def ajax_pb_and_photo
    gchat = Gchat.find_by_id(params[:id])
    pid = gchat.txt.slice(5,24)
    gchat.set(:del, true)
    photo = Photo.find_by_id(pid)
    photo.set(:hide, true) if photo
    render :json => {}
  end

end

