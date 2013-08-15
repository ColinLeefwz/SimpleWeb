# coding: utf-8
class XgroupController < ApplicationController

  def create
    errmsg = blank_check(:id, :data)
    return render :json => {error: errmsg} if errmsg
    return render :json => {error: "id已有"} if Group.find_by_id(params[:id])
    data = params[:data]
    begin
      group = Group.new(name: data['name'], line_id: data['line_id'], fat: data['fat'], tat: data['tat'], code: data['tid'], users: data['users'],admin_sid: 21834762 )
      group.id = params[:id]
      group.gen_shop
      group.save!
    rescue
      return render :json => {error: 'data数据格式错误'}
    end

    #团建好后，把已经有的用户认证。
    group.reload.bat_phone_auth
    group.create_shop_faq
    render :json => {ok: group.id}
  end


  def find
    return render :json => {error: "id必填"} if params[:id].blank?
    group = Group.find_by_id(params[:id])
    if group
      render :json => {data: group.attributes}
    else
      render :json => {error: "id不存在"}
    end
  end

  

  def blank_check(*arr)
    arr.each{|a| return "#{a.to_s}必填" if params[a].blank?}
    return nil
  end
end
