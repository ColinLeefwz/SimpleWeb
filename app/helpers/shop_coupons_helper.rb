# encoding: utf-8
module ShopCouponsHelper
  def rulev_lable(v)
    case v
    when 1
      '前几名：'
    when 3
      '累计次数：'
    end
  end
  
  def age(birthday)
    return if birthday.blank?
    l = Time.now.to_date
    b = birthday
    a = l.year-b.year
    a-1 if "#{l.month}#{l.day}" < "#{b.month}#{b.day}"
  end
end
