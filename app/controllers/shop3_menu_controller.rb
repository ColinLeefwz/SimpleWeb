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
    butn_hash = params[:button]
    butn_hash['url'] = URI.encode(URI.unescape(butn_hash['url'].strip)) #TODO:加测试
    butn.merge!(butn_hash)
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
    session_shop.set(:has_menu, 2)
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

  def sort_menu
    menu = Menu.find_by_id(session[:shop_id])
    button = menu.button
    tmp_button = []
    params[:index].each_with_index do |hash_arr, index|
      tmp_button[index] = button[hash_arr[0].to_i]
      if hash_arr[1].is_a?(Array)
        tmp_button[index]['sub_button'] = hash_arr[1].map{|m| button[hash_arr[0].to_i]['sub_button'][m.to_i]}
      end
    end 
    menu.button = tmp_button
    menu.save
    render :json => menu.reload.view_json
  end 

end