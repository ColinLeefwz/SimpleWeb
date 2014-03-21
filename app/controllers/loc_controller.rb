# coding: utf-8

class LocController < ApplicationController
  layout nil
  
  def real2gcj
    lo=[params[:lat].to_f, params[:lng].to_f]
    ret = Shop.lo_to_log(lo)
    render :json => {lat:ret[0], lng:ret[1]}
  end

  def real2bd09
    lo=[params[:lat].to_f, params[:lng].to_f]
    ret = Shop.lo_to_lob(lo)
    render :json => {lat:ret[0], lng:ret[1]}
  end  
  

  def gcj2real
    lo=[params[:lat].to_f, params[:lng].to_f]
    ret = Shop.lob_to_lo(lo)
    render :json => {lat:ret[0], lng:ret[1]}
  end
  
  def bd092real
    lo=[params[:lat].to_f, params[:lng].to_f]
    ret = Shop.lob_to_lo(lo)
    render :json => {lat:ret[0], lng:ret[1]}
  end
    
end
