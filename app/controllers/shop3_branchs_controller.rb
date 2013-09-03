

class Shop3BranchsController < ApplicationController
  before_filter :shop_authorize
  layout 'shop3'
  
  def index
    
  end

end
