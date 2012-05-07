module Alipay
 
  @@gateway = "https://www.alipay.com/cooperate/gateway.do?" #支付接口
  @@send_gateway = "https://mapi.alipay.com/gateway.do?" #确认发货接口
  @@partner= "2088201909435470" #2088002053153634" #合作伙伴ID2088201909435470 4ae1g2mm2468hrrnrea4nproz5gsk8h2
  @@security_code = "4ae1g2mm2468hrrnrea4nproz5gsk8h2" # "9fkjby5pbzscg61vil4pf6xwlp8b9w6d" #安全检验码4ae1g2mm2468hrrnrea4nproz5gsk8h2
  @@seller_email = "hr@1dooo.com" #卖家支付宝帐户
  @@mysign = "" #签名 b932c1e9c67a037fe31ed358d1b66877
  @@parameter = ""
  @@sign_type="MD5" #加密方式 系统默认
  @@_input_charset="utf-8" #字符编码格式
  @@transport="https" #访问模式
  @@subject="一渡网会员充值"
  
  @@logistics_type = "EXPRESS"
  @@logistics_fee = 0
  @@logistics_payment = "SELLER_PAY"

  @@receive_name = "name"
  @@receive_address = "address"
  @@receive_zip = ""
  @@receive_phone = ""
  @@receive_mobile = ""

  def pay(recharge, notify_url, return_url, subject=@@subject, body=@@subject)
    alipay_service(create_parameter(recharge, notify_url, return_url, subject, body), @@security_code,@@sign_type,@@transport)
    redirect_to create_url, :target => "_black"
  end

  def notify(parameters)
    recharge = currentRecharge(parameters[:out_trade_no])
    if !parameters[:notify_type].nil? && !parameters[:notify_id].nil? &&  !parameters[:notify_time].nil? && !parameters[:sign].nil?  && !parameters[:sign_type].nil?
      if (return_verify(parameters) && params[:trade_status]=="WAIT_SELLER_SEND_GOODS" && parameters[:total_fee].to_f==recharge.money && recharge.state== false)
        recharge.update_attributes!({ "paytime" => DateTime.now, "detail" => "", "state" => true })
      end
      return true
    else
      return false
    end
  end

  def currentRecharge(out_trade_no)
    return Recharge.find_by_outtradeno(out_trade_no)
  end

  def create_parameter(recharge, notify_url = nil, return_url = nil, subject=@@subject, body=@@subject)
    notify_url = "http://www.1dooo.com/recharges/pay_notify" if notify_url.blank? #交易过程中服务器通知的页面 要用 http://格式的完整路径
    return_url = "http://www.1dooo.com/recharges/pay_return" if return_url.blank? #付完款后跳转的页面 要用 http://格式的完整路径
     @parameter = {
      # "service" => "create_direct_pay_by_user",  # 即时到帐
      "service" => "create_partner_trade_by_buyer",  # 担保交易
      # "service" => "trade_create_by_buyer",  # 实物交易
      "partner" => @@partner, #合作商户号
      "return_url" => return_url, #同步返回
      "notify_url" => notify_url, #异步返回
      "_input_charset" => @@_input_charset, #字符集，默认为GBK
      "subject" => subject, #商品名称，必填
      "body" => subject, #商品描述，必填
      "out_trade_no" => recharge.outtradeno, #商品外部交易号，必填（保证唯一性）
      "payment_type" => "1", #默认为1,不需要修改
      "total_fee" => recharge.money,
      "quantity" => "1",
      "price" => recharge.money,
      "show_url" => "http://www.gabriel-beer.cn/shop_space/menu/518?shop_id=712", #商品相关网站
      "seller_email" => @@seller_email, #卖家邮箱，必填
      "logistics_type" => @@logistics_type,
      "logistics_fee" => @@logistics_fee,
      "logistics_payment" => @@logistics_payment,
      "receive_name" => @@receive_name,
      "receive_address" => @@receive_address,
      "receive_zip" => @@receive_zip,
      "receive_phone" => @@receive_phone,
      "receive_mobile" => @@receive_mobile,
    }
    return @parameter
  end

  def alipay_service(parameter,security_code,sign_type,transport)
    @@parameter = para_filter(parameter)
    @@sign_type = sign_type
    @@mysign = ''
    @@transport = transport
    if(parameter['_input_charset'] == "")
      @@parameter['_input_charset']='GBK'
    end
    if(@@transport == "https")
      @@gateway = "https://www.alipay.com/cooperate/gateway.do?"
    else
      @@gateway = "http://www.alipay.com/cooperate/gateway.do?"
    end
    sort_array = {}
    arg = ""
    sort_array = @@parameter
    sort_array.keys.sort.each do |key|
      if (key != "sign" && key != "sign_type" )
        arg += "#{key}=#{sort_array[key]}&"
      end
    end
    prestr = arg[0,arg.length-1].to_s
    @@mysign = sign(prestr+security_code)
  end

  def para_filter(parameter) #除去数组中的空值和签名模式
    para = {}
    parameter.keys.each do |key|
      if !(key == "sign" || key == "sign_type" || parameter[key] == "")
        para[key] = parameter[key]
      end
    end
    return para
  end

  def sign(prestr)
    mysign = ""
    if(@@sign_type == 'MD5')
      mysign = Digest::MD5.hexdigest(prestr)
    elsif (@@sign_type =='DSA')
      #DSA 签名方法待后续开发
      exit("DSA 签名方法待后续开发，请先使用MD5签名方式")
    else
      exit("支付宝暂不支持"+@@sign_type+"类型的签名方式")
    end
    return mysign
  end

  def create_url
    url = @@gateway
    sort_array = {}
    arg = ""
    sort_array = @@parameter
    sort_array.keys.sort.each do |key|
      arg+=key+"="+URI.escape(sort_array[key].to_s)+"&"
    end
    url+=arg+"sign="+@@mysign+"&sign_type="+@@sign_type
    return url
  end

  def return_verify(ps)
    sort_get={}
    sort_get= ps
    arg=""
    sort_get.keys.sort.each do |key|
      if (key != "sign" && key != "sign_type" && key !="action" && key != "controller")
        arg += "#{key}=#{sort_get[key]}&"
      end
    end
    prestr = arg[0,arg.length-1] #去掉最后一个&号
    return sign(prestr+@@security_code) == sort_get["sign"]
  end
end
