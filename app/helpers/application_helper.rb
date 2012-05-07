# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def show_dooo_captcha(options={})
    %Q{
                <input type="text" size="10" name="captcha" id="captcha"><img width="75" src="/util/captcha_img" id="captcha_img"/>
                <script>
                  function changeImage(){
                    document.getElementById("captcha_img").src = "/util/captcha_img?id="+new Date().getTime(); // Math.random();
                  }
                changeImage();
          </script>
        }
    end

      def add_to_cart(discount)
        s=form_remote_tag(:url => "/cart/add/#{discount.id}") do
          submit_tag '加入购物车'
        end
        s
      end

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

    def subshop_select
      s=""
      if(session_shop? && session_shop.subshops.count>0)
        s+="<input id='discount_subshops_0' type='checkbox' name='discount[subshops][]' checked='checked' value=''/>&nbsp;总店和所有分店(缺省)&nbsp;&nbsp;"
        s+="<input onclick='sel(this)' type='checkbox' name='discount[subshops][]' value='#{session_shop.phone}'/>&nbsp;总店&nbsp;&nbsp;"
        session_shop.subshops.each do |x|
          s+="<input onclick='sel(this)' type='checkbox' name='discount[subshops][]' value='#{x.phone}'/>&nbsp;#{x.name}&nbsp;&nbsp;"
        end
      end
      s+="<script>function sel(c){document.getElementById('discount_subshops_0').checked=false;if(c.checked) document.getElementById('discount_desc').innerHTML+=c.nextSibling.data+',' }</script>"
      s
    end

    def subshop_select2
      s=""
      if(session_shop? && session_shop.subshops.count>0)
        s+=check_box_tag("discount[subshops][]", "" )
        s+="总店和所有分店(缺省)<br />"
        s+=check_box_tag("discount[subshops][]", "#{session_shop.phone}" )
        s+="总店<br />"
        session_shop.subshops.each do |x|
          s+=check_box_tag("discount[subshops][]", x.phone )
          s+="#{x.name}<br />"
        end
      end
      s
    end

    def discount_multi_select
      ret=[]
      i=0
      while i<61
        a=Discount.multi_range[i]
        b=Discount.multi_name[i]
        ret << [ b,a ]
        i+=1
      end
      ret
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

    def is_radio107?
      true if session[:shop_id].to_s == "187"
      #    true if session[:shop_id].to_s == "152"
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

    def text_field_with_auto_complete_1dooo(object, method = :name,
                                            tag_options = {:size => 30, :onclick => "#{object}_#{method}_auto_completer.activate();"},
                                            completion_options = {:url => "/"+object.to_s+"s.js", :method => :get, :with => "'name='+element.value", :after_update_element => :getSelectionId, :indicator => "indicator"+object.to_s})

      text_field(object, method, tag_options) +%Q{
        <span id="indicator#{object}" style="display: none">
          <img src="/images/spinner.gif" alt="Working..." />
        </span>
      }+
    (completion_options[:skip_style] ? "" : auto_complete_stylesheet) +
    content_tag("div", "", :id => "#{object}_#{method}_auto_complete", :class => "auto_complete") +
    auto_complete_field("#{object}_#{method}", { :url => { :action => "auto_complete_for_#{object}_#{method}" } }.update(completion_options))

    #text_field_with_auto_complete(object, method, tag_options, completion_options)
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


    end

