class Dashboard::BaseController < ApplicationController

  before_filter :find_space

  def find_space
    @space = MobileSpace.find_by :name => params[:space_id]
  end

end