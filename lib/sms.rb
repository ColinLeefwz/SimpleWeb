class Sms

  def self.log(msg,level=2)
    ActiveRecord::Base.logger.add level, "SMS:\t#{msg}"
    File.open("sms.log","a") {|f| f.puts "SMS:\t#{msg}"}
  end

  def self.self_check_log(msg)
    File.open("self_check.log","a") {|f| f.puts msg}
  end

  def self.handle(sms)
    sms.SM_Content=sms.SM_Content[3,sms.SM_Content.length-3] if sms.SM_Content[0,4]=="???["
    self.backup(sms)

    #处理商家以及用户活动短信
    if sms.SM_Content[0,3] == '[[Q'
      sms.Readed = 1
      ActiveRecord::Base.logger.add 2, "new Consumption\n"
      ActiveRecord::Base.transaction do
        sms.save!
        FSLock.new("/tmp/bodu_rails_app") do
          Consumption.gen_from_sms(sms.SM_Content,sms.OrgAddr)
        end
      end
    elsif sms.SM_Content[0,3] == '[[x'
      sms.Readed = 1
      ActiveRecord::Base.transaction do
        sms.save!
        FSLock.new("/tmp/bodu_rails_app") do
          DcashXf.gen_from_sms(sms.SM_Content,sms.OrgAddr)
        end
      end
    elsif sms.SM_Content[0,3] == '[[r'
      sms.Readed = 1
      sms.save
      Discount.resend(sms.SM_Content,sms.OrgAddr)
    elsif sms.SM_Content[0,3] == '996'
      ActiveRecord::Base.transaction do
        FSLock.new("/tmp/bodu_rails_996") do
          sms.Readed = 1
          sms.save!
          self.radio996(sms.SM_Content[3,sms.SM_Content.length], sms.OrgAddr)
        end
      end
    elsif sms.SM_Content[0,3] == '107'
      ActiveRecord::Base.transaction do
        FSLock.new("/tmp/bodu_rails_107") do
          sms.Readed = 1
          sms.save!
          self.radio107(sms.OrgAddr)
        end
      end
    elsif sms.SM_Content[0,8] == '85777979'
      ActiveRecord::Base.transaction do
        FSLock.new("/tmp/bodu_rails_kb") do
          sms.Readed = 1
          sms.save!
          self.kb(sms.OrgAddr)
        end
      end
    elsif sms.SM_Content[0,5].downcase == '1dooo' #增加大小写忽略判断
      ActiveRecord::Base.transaction do
        FSLock.new("/tmp/bodu_rails_tgbao") do
          sms.Readed = 1
          sms.save!
          self.tgbao(sms.OrgAddr)
        end
      end
    elsif sms.SM_Content[0,3] == '[[['
      ActiveRecord::Base.transaction do
        FSLock.new("/tmp/bodu_rails_consumption") do
          sms.Readed = 1
          sms.save
          Consumption.self_check(sms.SM_Content,sms.OrgAddr)
        end
      end
    elsif sms.SM_Content[0,3] == '[[q'
      ActiveRecord::Base.transaction do
        FSLock.new("/tmp/bodu_rails_q") do
          sms.Readed = 1
          sms.save
          discount_id = sms.SM_Content[3,10].to_i
          user_id = sms.SM_Content[13,10].to_i
          cc=Consumption.find_by_user_id_and_discount_id(user_id,discount_id)
          unless cc.nil?
            cs="[["
            hex="Q"+sms.SM_Content[3,10]+sms.SM_Content[13,10]
            hex+=SmsUtil.fill_zero(cc.money.to_s,10)
            cs += hex
            cs += Digest::SHA1.hexdigest("ylt"+hex+SmsUtil.fill_zero(self.shop.id.to_s,8))[0,8]
            cs += SmsUtil.fill_zero(cc.phone,13)
            SmsOut.send_sms(cs, sms.OrgAddr)
          end
        end
      end
    elsif sms.SM_Content[0,1] == '0'
      ActiveRecord::Base.transaction do
        FSLock.new("/tmp/bodu_rails_0") do
          did=sms.SM_Content[3,sms.SM_Content.length-3]
          u=User.find_or_create_by_phone PhoneCompare.normalize(sms.OrgAddr)
          d = Ddown.new
          d.discount_id= did
          d.user_id = u.id
          d.phone = PhoneCompare.normalize(u.phone)
          begin
            d.save!
          rescue  Exception => error
            SmsOut.send_sms("#{error}", u.phone)
          end
          sms.Readed = 1
          sms.save
        end
      end
    elsif sms.SM_Content[0,3].downcase == 'cuc'
      ActiveRecord::Base.transaction do
        FSLock.new("/tmp/bodu_rails_wyyh") do
          self.ccg_wyyh(sms.OrgAddr)
          # u=User.find_or_create_by_phone PhoneCompare.normalize(sms.OrgAddr)
          # SmsOut.send_sms('前４位我要优惠中文短信收到后回发短信', u.phone)
          sms.Readed = 1
          sms.save
        end
      end
    elsif sms.SM_Content[0,8].downcase == '我要优惠'
      ActiveRecord::Base.transaction do
        FSLock.new("/tmp/bodu_rails_wyyh_zh") do
          SmsOut.send_sms('前8位13989841042我要优惠中文短信收到后回发短信', '13989841042')
          # u=User.find_or_create_by_phone PhoneCompare.normalize(sms.OrgAddr)
          # SmsOut.send_sms('前８位我要优惠中文短信收到后回发短信', u.phone)
          sms.Readed = 1
          sms.save
        end
      end
    else
      sms.Readed = 1
      sms.save
    end
  end

  def self.backup(sms)
    bak=SmsIn.new
    bak.text=sms.SM_Content
    bak.originator=sms.OrgAddr
    bak.original_ref_no=sms.DestAddr
    bak.receive_date=Time.now

    #处理用户上行短信（优惠券+现金券）
    if sms.SM_Content[0,1] == '[' && sms.SM_Content[1,1] != '['
      bak.process=1 #短信待处理标志
      begin
        if sms.SM_Content.mb_chars[16,1].to_s == "-" #现金券联网
          id = Int60.to10 sms.SM_Content[sms.SM_Content.index('-')+1,5]
          dcash = Dcash.find_by_id(id)
          bak.gateway_id=dcash.shop_id
          unless dcash.shop.network #现金券不联网
            bak.process=0
            if PhoneCompare.equal(dcash.phone , sms.OrgAddr)
              #TODO: 安全性检查
              dsms = sms.SM_Content.mb_chars[0,31]
              dsms += SmsUtil.fill_zero(dcash.quantity.to_s,5)
              dsms += SmsUtil.fill_zero(dcash.used.to_s,5)
              dsms += '-'
              dsms += SmsUtil.fill_zero(sms.OrgAddr,13)
              puts dsms
              SmsOut.send_sms(dsms, dcash.shop.phone2_to_phone(sms.DestAddr))
            end
          end
        else #优惠券
          did = Int60.to10 sms.SM_Content.mb_chars[16,5]
          discount = Discount.find_by_id(did)
          bak.gateway_id=discount.shop_id
          unless discount.shop.network
            bak.process=0
            dsms = sms.SM_Content.mb_chars[0,41]
            dsms += '-'
            dsms += SmsUtil.fill_zero(sms.OrgAddr,13)
            SmsOut.send_sms(dsms, discount.shop.phone2_to_phone(sms.DestAddr))
          end
        end
      rescue   Exception => error
        #debugger
        Sms.log(error)
      end
    else
      bak.process=0
    end
    begin
      bak.save! #上行短信保存
    rescue  Exception => error
      Sms.log(error)
    end
  end

  def self.radio996(discount_id, phone)
    user=User.find_or_create_by_phone(PhoneCompare.normalize(phone))
    # @radio996 = Radio996.find_by_sql("select discount_id, discount_id2, start_time, end_time from radio996s where sec_now = 1 order by id desc limit 1")
    @radio996 = Radio996.find_by_discount_id(discount_id)
    discount=Discount.find_by_id(@radio996.discount_id)
    if (@radio996.start_time > Time.zone.now)
      # 还没开始秒杀
      # 秒杀活动“996电台秒杀现金券”将于 2010-06-23 15:20:00 开始，敬请关注！
      s = "秒杀活动“#{discount.name}”将于 #{@radio996.start_time.strftime("%Y-%m-%d %H:%M:%S")} 开始，敬请关注！"
      SmsOut.send_sms(s,phone)
    elsif @radio996.end_time < Time.zone.now
      # 秒杀活动“996电台秒杀现金券”已于 2010-06-23 15:20:00 结束，感谢您的参与！
      s = "秒杀活动“#{discount.name}”已于 #{@radio996.end_time.strftime("%Y-%m-%d %H:%M:%S")} 结束，感谢您的参与！"
      SmsOut.send_sms(s,phone)
    elsif discount.circulation <= Order.total_amount(discount.id)
      # 秒杀未结束，但现金券已被秒杀完
      if @radio996.discount_id2 > 0
        Ddown.dispatch(user,@radio996.discount_id2, 'r996')
      end
    else
      # 生成订单
      @cart = Cart.new
      @cart.add_product(discount)
      @order = Order.new
      @order.add_line_items_from_cart(@cart)
      @order.user = user
      @order.total_price = @cart.total_price
      @order.save
      # 您已成功秒杀“996电台秒杀现金券”，请登录www.1dooo.com下载您的现金券！
      s = "您已成功秒杀“#{discount.name}”，请登录www.1dooo.com下载您的现金券！"
      SmsOut.send_sms(s,user.phone)
    end
  end

  def self.radio107(phone)
    r107=Radio107.cur_107

    if r107.nil?
      SmsOut.send_sms("感谢您参与一渡网FM107天天美食活动,登陆一渡网www.1dooo.com,享天天美食特惠!",phone)
      return
    end
    user=User.find_or_create_by_phone(PhoneCompare.normalize(phone),true,"",false)
    time = Time.zone.now
    if r107.sec_now > time || r107.sec_end < time
      SmsOut.send_sms("感谢您参与一渡网FM107天天美食活动,登陆一渡网www.1dooo.com,享天天美食特惠!",phone)
    else
      unless r107.sec_ended?
        Ddown.dispatch(user,r107.discount_id, 'r107')
        Ddown.dispatch(user,r107.discount_id2, 'r107')
      else
        Ddown.dispatch(user,r107.discount_id2, 'r107')
      end
    end
  end

  def self.kb(phone)
    kb=Kb.cur_kb
    if kb.nil?
      SmsOut.send_sms("感谢您参与一渡网快报美食活动,请在活动有效期内发送短信,登陆一渡网www.1dooo.com,享天天美食特惠!",phone)
      return
    end
    user=User.find_or_create_by_phone(PhoneCompare.normalize(phone),true,"",false)
    Ddown.dispatch(user,kb.discount_id, 'kb')
  end

  #团购报活动
  def self.tgbao(phone)
    tgb = Tgbao.cur_tgbao

    if tgb.nil?
      SmsOut.send_sms("感谢您参与本次活动，免费券已全部赠送完毕，登陆1dooo.com,体验2010短信送礼新模式:礼到轻松,信领神会!咨询4006655107",phone)
      return
    end

    user = User.find_or_create_by_phone(PhoneCompare.normalize(phone),true,"",false)

    unless tgb.tgbaos_ended?
      Ddown.dispatch(user, tgb.discount_id, 'tgb') #下发0元特价券
      Ddown.dispatch(user, tgb.discount_id2, 'tgb') #下发折扣券
      #Ddown.dispatch(user, tgb.discount_id, 'tgb2')
      #SmsOut.send_sms("恭喜您获得三山湖蟹商行提供的价值30元的阳澄好记牌正宗阳澄湖大闸蟹1只,9月17-30日提取有效!提货点详情登陆1dooo.com ,咨询4006655107",phone)
    else
      SmsOut.send_sms("感谢您参与本次活动，免费券已全部赠送完毕，登陆1dooo.com,体验2010短信送礼新模式:礼到轻松,信领神会!咨询4006655107",phone)
    end
  end

  #粗菜馆我要优惠
  def self.ccg_wyyh(phone)
    user=User.find_or_create_by_phone(PhoneCompare.normalize(phone))
    shop = Shop.find_by_id(209)
    discounts = Discount.find(:all, :conditions => ["shop_id = ? and beginday <= ? and endday >= ? and remainder > 0 and t = 'z' and (money = 0 or money is null) and status = 1 and var_dsct like '%;%'", shop.id, Time.now, Time.now], :order => "beginday desc")
    discount = discounts.first
    if discount
      d = Ddown.new
      d.discount_id= discount.id
      d.user_id = user.id
      d.phone = PhoneCompare.normalize(user.phone)
      begin
        d.save!
      rescue  Exception => error
        SmsOut.send_sms("#{error}", user.phone)
      end
    else
      SmsOut.send_sms("本次优惠已结束，敬请期待下次优惠", user.phone)
    end
  end
end
