<<<<<<< HEAD
module ApplicationHelper
  def flash_class
    if flash[:alert]
      "alert-danger"
    elsif flash[:error]
      "alert-something"
    elsif (flash[:notice] or flash[:success])
      "alert-success"
    end
  end

  def flash_message
    flash[:alert] || flash[:error] || flash[:notice] || flash[:success]
  end



  # helper for displaying price
  def price_tag(price)
    if price == 0
      return "Free"
    else
      return number_to_currency(price, :unit => "$") + "USD"
    end
  end


  ## payment
  # display the enroll button(free) or paypal button
  def paypal_or_enroll_button(params, item)

    if (current_user) && (current_user.enrolled? item)
      "Enrolled"
    else
      if item.free?
        link_to "Confirm", "/#{params[:controller]}/#{item.id}/enroll_confirm", class: "btn"
      else
        link_to image_tag("paypal_button.png"), send("purchase_#{item.class.name.downcase}_path", item.id), data: {no_turbolink: true}
      end
=======
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
    session_shop.mweb && session[:admin_sid].blank?
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
>>>>>>> b8c272e31d97492bb030400d7034cb2d7a03ce34
    end
  end


<<<<<<< HEAD
  # use devise helper outside of Users::RegistrationsController
  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  def resource
    @resource ||= User.new
  end

  def resource_name
    :user
  end

  def resource_class
    devise_mapping.to
  end



  # dynamic form
  def link_to_remove_fields(name, f)
    f.hidden_field(:_destroy) + link_to(name, "#", class: "btn remove-fields inline")
  end

  def link_to_add_fields(name, f, associaton)
    new_object = f.object.send(associaton.to_s).build
    fields = f.fields_for(associaton, new_object, child_index: "new_#{associaton}") do |builder|
      render(associaton.to_s.singularize + "_fields", f: builder)
    end

    link_to(name, "#", class: "btn add-fields inline", data: {associaton: associaton.to_s, fields: fields.gsub("\n", "") } )
  end
end
=======
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
    html += "<span class='current'>第</span><input type='text' name='page' value='#{@page}'><span class='current'>页</span>"
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

>>>>>>> b8c272e31d97492bb030400d7034cb2d7a03ce34
