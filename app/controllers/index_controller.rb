
class IndexController < ApplicationController
  
  before_filter :weixin_filter, :only => [:index]

  def index
    render :layout => false
  end
  
end