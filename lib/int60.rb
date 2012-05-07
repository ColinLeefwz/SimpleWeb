# To change this template, choose Tools | Templates
# and open the template in the editor.

class Int60
  @@a = ['0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z','a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x']

  def self.to60(int10)
    int10=int10.to_i
    s=""
    while(int10>0)
      r=int10%60
      int10=int10/60
      s +=@@a[r]
    end
    s.reverse
  end

  def self.to10_bit(bit)
    i=0
    while i<60
      return i if @@a[i]==bit
      i+=1
    end
  end

  def self.to10(int60)
    s=int60.to_s
    ret=0;i=0
    while i<s.length
      ret=ret*60+to10_bit(s[i].chr)
      i+=1
    end
    ret
  end
end
