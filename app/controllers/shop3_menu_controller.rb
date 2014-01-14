class Shop3MenuController < ApplicationController
  before_filter :shop_authorize
  layout "shop3"

  def index
  	@menu = Menu.find_by_id(session[:shop_id])
    logo = session_shop.logo
    @logo = (logo ? logo.img.url(:t1) : '/newbackstage/images/pic1.png')
  	respond_to do |format|
  		format.html
  		format.json {render :json => @menu ? @menu.view_json : {menu: {button: []}}}
  	end
  end

  def add_menu
  	menu = Menu.find_by_id(session[:shop_id])
  	if menu
  		button = menu.button
  		if params[:index]!='null'
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
  	render :json => menu.view_json
  end

  def edit_menu
    menu = Menu.find_by_id(session[:shop_id])
    indexs = params[:index]
    butn = menu.button[indexs.shift.to_i]
    butn = butn['sub_button'][indexs.first.to_i] if indexs.any?
    butn['name'] = params[:name]
    menu.save
    render :json => menu.view_json
  end

  def set_view_action
    menu = Menu.find_by_id(session[:shop_id])
    indexs = params[:index]
    butn = menu.button[indexs.shift.to_i]
    butn = butn['sub_button'][indexs.first.to_i] if indexs.any?
    butn.merge!(params[:button])
    menu.save
    render :json => menu.view_json
  end

  def set_click_action
    menu = Menu.find_by_id(session[:shop_id])
    indexs = params[:index].dup
    butn = menu.button[indexs.shift.to_i]
    butn = butn['sub_button'][indexs.first.to_i] if indexs.any?
    butn['type'] = 'click'
    butn['key'] ||= "V#{session[:shop_id].to_i}_#{Time.now.to_i}"
    menu.save! 
    mk = MenuKey.find_by_id(butn['key'])
    if mk
      mk.update_attributes(params[:menu_key])
    else
      mk = MenuKey.new(params[:menu_key])
      mk._id = butn['key']
      mk.save
    end
    render :json => menu.view_json
  end

  def pub
    session_shop.set(:has_menu, true)
    render :json => 1
  end

  def del
  	menu = Menu.find_by_id(session[:shop_id])
  	index = params[:index].map{|m| m.to_i}
  	if index.length ==2
  		menu.button[index.first]['sub_button'].delete_at(index.last)
  	else
  		menu.button.delete_at(index.first)
  	end
  	menu.save
  	render :json => menu.view_json
  end

end