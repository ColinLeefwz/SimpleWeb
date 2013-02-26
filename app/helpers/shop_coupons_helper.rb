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
end
