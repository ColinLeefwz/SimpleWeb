
module PhoneUtil
  
  def is_dianxin(phone)
    is_dianxin_cdma(phone) ## || is_dianxin_xlt(phone)
  end
  
  def is_dianxin_cdma(phone)
    ["133","153","180","181","189"].find{|x| x==phone[0,3]} != nil
  end
  
  def is_dianxin_xlt(phone)
    phone[0]=="0"
  end
  
  def is_liantong(phone)
    ["130","131","132","145","155","156","185","186"].find{|x| x==phone[0,3]} != nil
  end
  
  def is_yidong(phone)
    ["134","135","136","137","138","139","147","150","151","152","157","158","159","182","183"].find{|x| x==phone[0,3]} != nil
  end
  
  def is_phone?(str)
    str.size==11 && str.to_i>10000000000
  end
  
  def phone_operator(phone)
    return "移动" if is_yidong(phone)
    return "联通" if is_liantong(phone)
    return "电信" if is_dianxin(phone)
    return "未知运营商"   
  end

  
  def phone_hidden(phone)
    return "" if phone.nil?
    s=phone.dup
    for i in 3..6
      break if i>s.length
      s[i]='*';
    end
    s
  end
  
  def phone_normalize(phone)
    return nil if phone.nil?
    s = phone.strip.gsub(/[-+]/,"")
    if s[0,2]=='86'
      s=s[2,s.length-2]
    elsif s[0,3]=='086'
      s=s[3,s.length-3]
    end
    s
  end
  
  def phone_equal(p1,p2)
    if normalize(p1)==normalize(p2)
      return true
    else
      return false
    end
  end

  
end