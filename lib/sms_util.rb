module SmsUtil

  def id_sms
    len = shop_id.to_s.length
    "#{len}#{shop_id}#{id}"
  end

  def parse_id_sms(text)
        len = text[0,1].to_i+1
	text[len,text.length-len]
  end

  def name_to_15
    len = self.discount.name.mb_chars.length
    if len > 15
      self.discount.name.mb_chars[0,15].to_s
    else
      diff=15-len
      self.discount.name+fill_zero("",diff)
    end
  end

 #将字符串s添加前缀0，使得其长度为len。
 #如果len_exception=true，那么当字符串s的长度大于len时抛异常
 def fill_zero(s,len,len_exception=true)
    if s.length>len
      raise "#{s}长度大于#{len}" if len_exception
      return s
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

  def self.fill_zero(s,len,len_exception=true)
    if s.length>len
      raise "#{s}长度大于#{len}" if len_exception
      return s
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
end

