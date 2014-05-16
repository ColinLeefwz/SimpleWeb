
class IndexController < ApplicationController
  
  before_filter :weixin_filter, :only => [:index]
  layout false


  
  def ip
    render :text => real_ip
  end
  
end