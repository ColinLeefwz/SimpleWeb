class StaticPagesController < ApplicationController

 def static
   requested_page = params[:page].sub "_"," "

   @static_page = StaticPages.where("lower(title) = ?", requested_page.downcase).first
   render 'static_pages'
 end
end
