# coding: utf-8
class AdminGchatContentReviewController < ApplicationController
  before_filter :admin_authorize
  include Paginate
  layout 'admin'
  
  def index
    hash = "this.txt.length > 30 && this.txt[0] !='[' && this.del != true"
    sort = {_id: -1}
    @gchat_review =  paginate3("Gchat", params[:page], hash, sort)
    # @gchat_review = Gchat.where("this.txt.length > 30 && this.txt[0] !='[' && this.del != true").limit(50)
  end

  def ajax_pb
    gchat = Gchat.find_by_id(params[:id])
    gchat.set(:del, true)
    render :json => {}
  end

end

