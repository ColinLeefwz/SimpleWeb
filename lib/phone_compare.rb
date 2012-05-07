# To change this template, choose Tools | Templates
# and open the template in the editor.

class PhoneCompare
  def PhoneCompare.normalize(phone)
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

  def PhoneCompare.form(phone)
    s = PhoneCompare.normalize(phone)
    return s.blank? ? false : (s =~ /^0?1((3)|(5)|(8))\d{9}$/) == 0
  end

  def PhoneCompare.equal(p1,p2)
    if normalize(p1)==normalize(p2)
      return true
    else
      return false
    end
  end

end
