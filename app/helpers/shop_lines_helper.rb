# coding: utf-8
module ShopLinesHelper
  def show_time(time)
    ts = time.split('/')
    case ts.length
    when 2
      "第#{ts[0]}天#{ts[1]}"
    else
      "时间错误"
    end
  end
end
