module Cbpay

  @@gateway = "https://pay3.chinabank.com.cn/PayGate" #支付接口
  @@v_mid = "21773115"      # 商户号，这里为测试商户号20000400，替换为自己的商户号即可
  @@key = "8530C52D739C750C"  # MD5密钥要跟订单提交页相同
  @@v_moneytype ="CNY"     # 币种
  @@mysign = "" #签名
  @@parameter = ""
  @@sign_type="MD5" #加密方式 系统默认
  @@_input_charset="utf-8" #字符编码格式
  @@transport="https" #访问模式

  def cbpay(recharge, notify_url)
    redirect_to cbcreate_url(recharge, notify_url)
  end

  def cbnotify(parameters)
    @v_oid = params[:v_oid]
    @v_pstatus = params[:v_pstatus]
    @v_pstring = params[:v_pstring]
    @v_amount = params[:v_amount]
    @v_moneytype = params[:v_moneytype]
    @v_md5str = params[:v_md5str]
    return (@v_md5str == sign(@v_oid.to_s+@v_pstatus.to_s+@v_amount.to_s+@v_moneytype.to_s+@@key.to_s).upcase) && @v_pstatus == "20"
  end

  protected
  def sign(prestr)
    mysign = ""
    if(@@sign_type == 'MD5')
      mysign = Digest::MD5.hexdigest(prestr)
    elsif (@@sign_type =='DSA')
      #DSA 签名方法待后续开发
      exit("DSA 签名方法待后续开发，请先使用MD5签名方式")
    else
      exit("网银在线暂不支持"+@@sign_type+"类型的签名方式")
    end
    return mysign
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

  def cbpay_to_shop(parameters)
    str = parameters[:v_oid].to_s+parameters[:v_pstatus].to_s+parameters[:v_amount].to_s+@@v_moneytype.to_s+@@key.to_s
    to_md5(str)
  end

  def to_md5(str)
    Digest::MD5.hexdigest(str).upcase
  end

  def cbcreate_url(recharge, v_url)
    v_url = "http://www.1dooo.com:#{request.port}/cbpay/cbpay_return" if v_url.blank?    #商户自定义返回接收支付结果的页面
    @v_oid = recharge.outtradeno
    @v_amount = recharge.money
    @v_url = v_url   #商户自定义返回接收支付结果的页面
    @v_md5info = sign(@v_amount.to_s+@@v_moneytype.to_s+@v_oid.to_s+@@v_mid.to_s+@v_url.to_s+@@key.to_s).upcase                         # 对拼凑串MD5私钥加密后的值，网银支付平台对MD5值只认大写字符串，所以小写的MD5值得转换为大写

    return "#{@@gateway}?v_md5info=#{@v_md5info}&v_mid=#{@@v_mid}&v_oid=#{@v_oid}&v_amount=#{@v_amount}&v_moneytype=#{@@v_moneytype}&v_url=#{CGI::escape(@v_url)}"
  end

  def currentrecharge(out_trade_no)
    return Recharge.find_by_outtradeno(out_trade_no)
  end

  def recharge_update(recharge, md5string, parameters)
    if (parameters[:v_md5str] == md5string && parameters[:v_pstatus]=="20" && parameters[:v_moneytype]== @@v_moneytype && @p_amount.to_f == recharge.money)
      hash =  {'outtradeno' => @p_oid, "paytime" => DateTime.now, "detail" => "", "state" => true }
      recharge.update_attributes! hash

      @return_msg << "您已通过网银成功支付，待达到最低团购人数时，您将获得团购券短信。"
      render(:text => "ok")
    else
      @return_msg << "付款失败，请联系客服人员。<br>本次交易流水号：#{parameters[:v_oid]}"
      render(:text => "ok")
    end

    flash[:notice]= @return_msg
  end
end
