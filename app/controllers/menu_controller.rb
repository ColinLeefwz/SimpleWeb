class MenuController < ApplicationController
  
  def get
    menu = Menu.find_by_id(params[:id])
    return render [].to_json if menu.nil?
    render menu.to_json
  end
  
  def create
    menu = Menu.new
    menu._id = params[:id].to_i 
    menu.button = JSON.parse(params[:button])
    menu.save
  end
  
  def delete
  end
  
  
end
