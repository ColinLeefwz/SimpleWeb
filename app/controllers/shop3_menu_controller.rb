class Shop3MenuController < ApplicationController
  before_filter :shop_authorize
  layout "shop3"

  def index
  	@menu = Menu.find_by_id(session[:shop_id])
  	respond_to do |format|
  		format.html
  		format.json {render :json => @menu.to_json}
  	end
  end

  def set
  	menu = Menu.find_by_id(session[:shop_id])
  	if menu
  		button = menu.button
  		if params[:index]
  			button[params[:index].to_i]['sub_button'].push({name: params[:name]})
  		else
  			button.push({name: params[:name], sub_button: [] })
  		end
  	else
  		menu = Menu.new
  		menu._id = session[:shop_id]
  		menu.button = [{name: params[:name], sub_button: [] }]
  	end
  	menu.save
  	render :json => 1
  end

  def set_action

  end

  def del
  	menu = Menu.find_by_id(session[:shop_id])
  	index = params[:index].split(",").map{|m| m.to_i}
  	if index.length ==2
  		menu.button[index.first]['sub_button'].delete_at(index.last)
  	else
  		menu.button.delete_at(index.first)
  	end
  	menu.save
  	render :json =>1 
  end



  

end