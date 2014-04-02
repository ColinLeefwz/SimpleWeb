# coding: utf-8

# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  #emoji表情显示
  def to_emoji(str)
    return if str.nil?
    s = str.gsub(/[^\d\s\w\u4e00-\u9fa5.|()；;,，]/)  do |e|
      unicode = e.unpack("U").first.to_s(16);
      Emoji::ED.include?(unicode) ? "<span class='emoji emoji#{unicode}'></span>" : e
    end
    s.html_safe
  end
  
  def text_to_html(str)
    "#{h(str)}".gsub(/\n/,'<br>').html_safe
  end

  def from_mweb?
    session[:source] == 'mweb'
  end

  def no_nav
    content_for :nav do
    end
  end

  def local_ip
    return ['115.199.102.9', '127.0.0.1'].include?(request.remote_ip)
  end

  def id_to_time(object_id, format = "%Y-%m-%d %H:%M")
    object_id.generation_time.localtime.strftime(format)
  end

  def img_gender(gender)
    case gender
    when 1
      image_tag("../images/sign6.jpg")
    when 2
      image_tag("../images/sign7.jpg")
    end
  end


  def link_weibo(user)
    if !user.wb_uid.blank?
      link_to '微博',user.try(:weibo_home)
    else
      "QQ"
    end
  end

 
  def generate_paginate(n=1)
    if params[:controller] =~ /3/
      render :partial => "/layouts/paginage", :locals => {:var => 4}
    else
      render :partial => "/layouts/paginage", :locals => {:var => n}
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

  def generate_paginate3
    return '' if @page==1 && @colls.to_a.length < @pcount
    html = "<form methods='get' action='#{url_for(request.params)}'>"
    html += %q(<div class="pagination r">)
    html += link_to "首页",request.params.merge!(:page => 1),:class => "prev_page"  if @page != 1
    html += link_to "上一页",request.params.merge!(:page => @page -1),:class => "prev_page"  if @page != 1
    html += "<span class='current'>第<input type='text' name='page' value='#{@page}'>页</span>"
    request.params.delete_if{|k, v| ['controller', 'action', 'page'].include?(k)}.each{|k,v| html += "<input type='hidden' name='#{k}' value='#{v}' />" }
    html +=  link_to "下一页",request.params.merge!(:page => @page + 1), :class => "next_page"  if @page != -1
    html +=  link_to "未页",request.params.merge!(:page => -1), :class => "next_page"  if @page
    html += "</div>"
    html += "</form>"
  end

  def select_pages(page, total_page)
    if page <=2
      1.upto(total_page).to_a[0,5]
    elsif (page+2) > total_page
      total_page.downto(1).to_a[0,5].reverse
    else
      (page-2).upto(page+2).to_a[0,5]
    end
  end

end

