# encoding: utf-8
#统计checkin_user_num, iso_num

class CountNum
  def self.preform
    SinaPoi.where({iso_num: {'$exists' => false}}).each do |poi|
      if poi.respond_to?(:datas)
        checkin_user_num = poi.datas.length
        iso_num = poi.datas.select{|s| s[2].to_s.match(/iphone|ipad/i) }.length
      else
        checkin_user_num, iso_num = 0 , 0
      end
      poi.update_attributes(:checkin_user_num => checkin_user_num, :iso_num => iso_num  )
    end
  end
end

CountNum.preform