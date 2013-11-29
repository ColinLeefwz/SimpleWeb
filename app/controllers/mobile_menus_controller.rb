class MobileMenusController < ApplicationController
  before_filter :shop_authorize
  layout "mobile"

  def index
    @mobile_space = MobileSpace.where({sid:session_shop.id}).first
  end

  def new
    @mobile_space = MobileSpace.where({sid:session_shop.id}).first
    if !params[:menu_name].nil?
      @mobile_space.menu << params[:menu_name] 
      if @mobile_space.save
        redirect_to "/mobile_menus/index"
      else
        render :action => "new"
      end
    else
      render :action => "new"
    end
  end

  def ajax_del
    @mobile_space = MobileSpace.where({sid:session_shop.id}).first
    @mobile_space.menu.delete_at(params[:id].to_i)
    if @mobile_space.save
      redirect_to "/mobile_menus/index"
    else
      redirect_to "/mobile_menus/index"
    end
  end

  def edit
    @mobile_space = MobileSpace.where({sid:session_shop.id}).first.menu[params[:id].to_i]
  end

  def update
    @mobile_space = MobileSpace.where({sid:session_shop.id}).first
    @mobile_article = MobileArticle.where({category: @mobile_space.menu[params[:id].to_i]})
    @mobile_article.each do |ma|
      ma.category = params[:menu_name]
      ma.save
    end
    @mobile_space.menu[params[:id].to_i] = params[:menu_name]
    if @mobile_space.save
      redirect_to "/mobile_menus/index"
    else
      render :action => "edit"
    end
  end

end