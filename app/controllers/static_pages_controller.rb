class StaticPagesController < ApplicationController
 def static
   requested_page = params[:page].sub!"_"," "
   @static_page = StaticPages.where(title: "#{requested_page}").first
   render 'static_pages'
 end 
end
