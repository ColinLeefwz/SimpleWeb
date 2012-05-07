# To change this template, choose Tools | Templates
# and open the template in the editor.

class PhoneUtil
  def PhoneUtil.phone_hidden(phone)
    return "" if phone.nil?
    s=phone.dup
    for i in 3..6
      break if i>s.length
      s[i]='*';
    end
    s
  end
end
