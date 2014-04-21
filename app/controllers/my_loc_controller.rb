# coding: utf-8

class MyLocController < ApplicationController
  
  before_filter :user_login_filter
  before_filter :user_is_session_user
  
  def get_locs
    my_loc = session_user.my_loc
    if my_loc
      ret = {}
      ret.merge!({home:my_loc.home.safe_output}) if my_loc.home
      ret.merge!({school:my_loc.school.safe_output}) if my_loc.school
      ret.merge!({building:my_loc.building.safe_output}) if my_loc.building
      render :json => ret.to_json
    else
      render :json => {}.to_json
    end
  end
  
  def set_loc
    loc = session_user.my_loc
    unless loc
       loc =  MyLoc.new
       loc._id = session_user._id
    end
    if params[:type]=="home"
      loc.sid1 = params[:sid].to_i
    elsif params[:type]=="school"
      loc.sid2 = params[:sid].to_i
    elsif params[:type]=="building"
      loc.sid3 = params[:sid].to_i
    else
      return render :json => {error:"错误的地点类型:#{params[:type]}"}.to_json
    end
    loc.save!
    render :json => {save:"ok"}.to_json
  end
  
  def select_loc
    lo = [params[:lat].to_f , params[:lng].to_f]
    hash = {lo:{'$near' => lo,'$maxDistance' => 0.1}, del:{"$exists" => false}}
    if params[:type]=="home"
      hash.merge!( {t:11} )
    elsif params[:type]=="school"
      hash.merge!( {t:12} )
    elsif params[:type]=="building"
      hash.merge!( {t:10} )
    else
      return render :json => {error:"错误的地点类型:#{params[:type]}"}.to_json
    end
    shops = Shop.where2(hash, {limit:100})
    ret = shops.map {|s| s.safe_output_with_users}
    render :json =>  ret.to_json  
  end



end
