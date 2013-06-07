# coding: utf-8
module ShopLinesHelper
  def show_time(time)
    ts = time.split(':')
    case ts.length
    when 2
      "第1天#{ts.join(':')}"
    when 3
      "第#{ts.shift}天#{ts.join(':')}"
    else
      "时间错误"
    end
  end
end
