
module PhoneUtil
  
  def is_phone?(str)
    str.size==11 && str.to_i>10000000000
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
    s = phone.strip
    if s[0,2]=='86'
      s=s[2,s.length-2]
    elsif s[0,3]=='086'
      s=s[3,s.length-3]
    elsif s[0,3]=='+86'
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