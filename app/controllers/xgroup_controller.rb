# coding: utf-8
class XgroupController < ApplicationController

  def create
    errmsg = blank_check(:id, :data)
    return render :json => {error: errmsg} if errmsg
    return render :json => {error: "id已有"} if Line.find_by_id(params[:id])
    data = params[:data]
    begin
      group = Group.new(name: data['name'], line_id: data['line_id'], fat: data['fat'], tat: data['tat'], code: data['tid'], users: data['users'],admin_sid: 21834762 )
      group.id = params[:id]
      group.save
    rescue
      render :json => {error: 'data数据格式错误'}
    end
    render :json => {ok: group.id}
  end


  def find
    
  end

  

  def blank_check(*arr)
    arr.each{|a| return "#{a.to_s}必填" if params[a].blank?}
    return nil
  end
end
