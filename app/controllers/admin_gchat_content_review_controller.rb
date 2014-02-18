# coding: utf-8
class AdminGchatContentReviewController < ApplicationController
  before_filter :admin_authorize
  include Paginate
  layout 'admin'
  
  def index
    # hash = {$where:"this.txt.length > 30 && (this.txt[0] !='[') "}
    # sort = {_id: -1}
    # @gchat_review =  paginate3("Gchat", params[:page], hash, sort)
    @gchat_review = Gchat.where("this.txt.length > 30 && (this.txt[0] !='[') ").limit(50)
  end

end

