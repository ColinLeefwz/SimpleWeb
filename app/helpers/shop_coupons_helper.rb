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

  def to_local(datetime, format = "%Y-%m-%d %H:%M")
    return datetime unless datetime.is_a?(Date)
    datetime = datetime.to_time.localtime
    datetime.strftime(format)
  end

end
