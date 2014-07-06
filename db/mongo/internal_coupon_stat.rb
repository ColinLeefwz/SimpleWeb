

module InternalCoupon
  DaDian = [21828768,3916696,3872771]
  ZongDian = [21835960, 1217422]



  def self.do_stat(day)
    time =   day.days.ago.localtime

    start_time = time.beginning_of_day
    end_time = time.end_of_day
    day = day.days.ago.strftime("%Y-%m-%d")

    #大地点内部小地点统计
    DaDian.each do |sid|
      cdown, cuse, data = 0, 0, {}
      s = Shop.find_by_id(sid)
      
      Shop.where({_id: {"$in" => s.shops}}).each do |shop|
        shop_data = {}
        CouponDown.where({sid: shop.id, dat: {"$gte" => start_time, "$lte" =>  end_time}}).each do |coupon_down|
          if scd = shop_data[coupon_down.cid.to_s]
            shop_data[coupon_down.cid.to_s] = [scd.first+1, scd.last]
          else
            shop_data[coupon_down.cid.to_s] = [1, 0]
          end
          cdown += 1
        end

        CouponDown.where({sid: shop.id, uat: {"$gte" => start_time, "$lte" =>  end_time}}).each do |coupon_down|
          if scd = shop_data[coupon_down.cid.to_s]
            shop_data[coupon_down.cid.to_s] = [scd.first, scd.last+1]
          else
            shop_data[coupon_down.cid.to_s] = [0, 1]
          end
          cuse +=1
        end
        data[shop.id] = shop_data unless shop_data.blank?
      end
      InternalCouponStat.create(cdown: cdown, cuse: cuse, day: day, sid: s.id, data: data)
     
    end


    #分店统计
    ZongDian.each do |sid|
      cdown, cuse, data = 0, 0, {}
      s = Shop.find_by_id(sid)

      s.branchs.each do |shop|
        shop_data = {}
        CouponDown.where({sid: shop.id, dat: {"$gte" => start_time, "$lte" =>  end_time}}).each do |coupon_down|
          if scd = shop_data[coupon_down.cid.to_s]
            shop_data[coupon_down.cid.to_s] = [scd.first+1, scd.last]
          else
            shop_data[coupon_down.cid.to_s] = [1, 0]
          end
          cdown += 1
        end

        CouponDown.where({sid: shop.id, uat: {"$gte" => start_time, "$lte" =>  end_time}}).each do |coupon_down|
          if scd = shop_data[coupon_down.cid.to_s]
            shop_data[coupon_down.cid.to_s] = [scd.first, scd.last+1]
          else
            shop_data[coupon_down.cid.to_s] = [0, 1]
          end
          cuse +=1
        end
        data[shop.id] = shop_data unless shop_data.blank?
      end
      InternalCouponStat.create(cdown: cdown, cuse: cuse, day: day, sid: s.id, data: data) 

    end
    
  end
  
end


1.times{|t| InternalCoupon.do_stat(t+1)}