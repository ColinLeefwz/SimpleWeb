# coding: utf-8

# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def no_nav
    content_for :nav do
    end
  end

  def my_page(o)
    will_paginate o ,:previous_label => '<<前一页' , :next_label => '后一页>>'
  end

  def zeros(len)
    ret=''
    len.times {|i|  ret='0'+ret }
    ret
  end

  def fill_zero(s,len)
    if s.length>len
      raise "#{s}长度大于#{len}"
    elsif s.length==len
      s
    else
      differ=len-s.length
      ret=''
      differ.times {|i|  ret='0'+ret }
      ret+=s
      return ret
    end
  end



  # 分页
  def generate_paginate(evariable, options ={})
    will_paginate evariable,{:class=>'pagination',:previous_label => '上一页', :next_label =>'下一页',:separator=>' '}.update(options)
  end


  def two_length_time(time, name)
    s = ""
    if time.nil?
      s = ""
    elsif name.nil?
      s = time.utc.to_s
    elsif name == "hour"
      s = time.hour.to_s.length != 1 ? time.hour.to_s : "0" + time.hour.to_s
    elsif (name == "min" || name == "minute")
      s = time.min.to_s.length != 1 ? time.min.to_s : "0" + time.min.to_s
    elsif (name == "sec" || name == "second")
      s = time.sec.to_s.length != 1 ? time.sec.to_s : "0" + time.sec.to_s
    end
    return s
  end


  def admin_select_opt
    init=["请选择",""]
    ret=Admin.find(:all).map {|u| [u.name,u.id]}
    ret.unshift init
  end

  def depart_select_opt
    init=["请选择",""]
    ret=Depart.find(:all).map {|u| [u.name,u.id]}
    ret.unshift init
  end

  def role_select_opt
    init=["请选择",""]
    ret=Role.find(:all).map {|u| [u.name,u.id]}
    ret.unshift init
  end

  def bool_select_opt
    [["是",true],["否",false]]
  end


  def accounts_type_select
    ["支付宝", "网银在线", "财付通", "深圳发展银行", "招商银行", "中国工商银行", "中国农业银行", "中国建设银行", "中国光大银行", "中国民生银行", "交通银行", "广东发展银行", "中信银行", "浦发银行", "兴业银行"]
  end

  def local_ip
    return ['115.199.102.9', '127.0.0.1'].include?(request.remote_ip)
  end

  def to_pail(balance)
    (balance/Qdhbeer::QIANDAOHU_BEER_PRICE).to_i
  end

  def repath(path, options={})
    return image_tag(domain_prefix(path), options) if ENV["RAILS_ENV"] == "production" || true
    image_tag(path, options)
  end

  def domain_prefix(path)
    return path if path =~ /^http:/
    img_name = path.split("/").last
    puts "path => '#{img_name}', name => '#{img_name[-5,1]}', value => '#{img_name[-5]}' "
    domain = {0 => "http://img1.1dooo.com", 1 => "http://img2.1dooo.com", 2 => "http://img3.1dooo.com" }[img_name[-5]%3]
    domain + path
  end

  def id_to_time(object_id)
    Time.at object_id.to_s[0,8].to_i(16)
  end


  def generate_paginate
    if (@total_entries+@pcount-1)/@pcount > 1
      html = "<form methods='get' action='#{url_for(request.params)}'>"
      html += %q(<div class="pagination r">)
      html += link_to "上一页",request.params.merge!(:page => @page -1),:class => "prev_page"  if @page != 1
      html += "<span class='current'>第<input type='text' name='page' value='#{@page}'>页</span>"
      request.params.delete_if{|k, v| ['controller', 'action', 'page'].include?(k)}.each{|k,v| html += "<input type='hidden' name='#{k}' value='#{v}' />" }
      html += "<a href='#' class='sum_page'>共#{@total_entries}页</a>"
      html +=  link_to "下一页",request.params.merge!(:page => @page + 1), :class => "next_page"  if @page
      html += "</div>"
      html += "</form>"
    else
      ''
    end
  end
  
  def generate_paginate2

    html = "<form methods='get' action='#{url_for(request.params)}'>"
    html += %q(<div class="pagination r">)
    html += link_to "上一页",request.params.merge!(:page => @page -1),:class => "prev_page"  if @page != 1
    html += "<span class='current'>第<input type='text' name='page' value='#{@page}'>页</span>"
    request.params.delete_if{|k, v| ['controller', 'action', 'page'].include?(k)}.each{|k,v| html += "<input type='hidden' name='#{k}' value='#{v}' />" }
    html +=  link_to "下一页",request.params.merge!(:page => @page + 1), :class => "next_page"  if @page
    html += "</div>"
    html += "</form>"
  end

end

