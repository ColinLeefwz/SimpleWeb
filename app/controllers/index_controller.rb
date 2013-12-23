
class IndexController < ApplicationController
  
  before_filter :weixin_filter, :only => [:index]

  def index
    render :layout => false
  end
  
  def ip
    render :text => real_ip
  end
  
end