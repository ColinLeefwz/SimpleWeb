class User < ActiveRecord::Base
  has_many :ddowns, :order => 'created_at DESC'
  has_many :consumptions, :order => 'created_at DESC'
  has_many :other_cs, :class_name => "Consumption", :foreign_key => "down_user_id"
  has_many :favorites
  has_many :orders, :order => 'created_at DESC'
  has_many :line_items, :through => :orders, :order => 'created_at DESC'
  has_many :dcashes
  has_many :dcash_xfs
  has_many :score_journals
  has_many :money_journals
  has_many :recharges
  has_many :gifts, :class_name => 'QdhBeerpresent', :foreign_key => 'from_user_id', :order => 'created_at DESC'

  has_many :user_logos
  has_one :user_logo, :conditions => 'thumbnail is null'
  has_one :user_logo_small, :class_name => "UserLogo", :conditions => "thumbnail='small'"
  has_one :user_logo_medium, :class_name => "UserLogo", :conditions => "thumbnail='medium'"
  belongs_to :shop
  has_many :user_shop_scores
  has_many :withdraw_cashes
  has_many :promotion_records
  has_many :comments
  has_many :beerorders
  has_many :beeruser_recharges
  has_many :beeruser_gifts
  has_many :articles
  has_many :shop_photos

  has_one :user_apply_ishop

  def user_appling_ishop
    UserApplyIshop.find_by_user_id_and_flag(id, 1)
  end

  def user_apply_ishop
    UserApplyIshop.find_by_user_id_and_flag(id, 2)
  end

#
#  validates_presence_of :name
#  validates_uniqueness_of :name
#  validates_confirmation_of 
#  validates_length_of :name, :in => 3..20
  #  validates_length_of :phone, :in => 11..12
  #  validates_numericality_of :phone, :only_integer => true
  validate :valid_upuserid

  def init_balance
    self.balance=0
    self.money_journals.each {|x| self.balance+=x.money}
  end

#  def validate
#    if PhoneCompare.form(name)
#      errors.add(:name, "注册用户名不能是手机号码") if phone.nil? || name != phone
#    end
#    return if phone.blank?
#    self.phone = PhoneCompare.normalize(self.phone)
#    if self.phone.length < 11
#      errors.add(:phone, "手机号码长度必须大于10位")
#    end
#  end

  def phones
    self.other_phones.to_s.split(',')
  end

  def after_validation_on_create
#    unless Shop.find_by_name(self.name).nil?
#      raise( "注册用户名已经被使用")
#    end
  end

  #个人用户升级为商家用户。此时商家表中的user_id为个人用户的id
  def upgrade_to_shop
    raise "'#{self.name}'已有对应的商家帐号" if my_shop
    shop          = Shop.new
    shop.name     = self.name
#    shop.password = self.password
    shop.address  = "请补充地址信息！"
    shop.tel      = self.phone.blank? ? '00000000' : self.phone
    shop.t        = 'b'
    shop.ver      = 0
    shop.network  = true
    shop.user_id  = self.id
    def shop.after_validation_on_create
      puts "cancel"
    end
    shop.save!
    return shop
  end

  #个人类型商家的商家账户
  def my_shop
#    Mshop.find_by_user_id(self.id)
  end

  def self.find_in_user_or_shop(name)
    u = User.find_by_name(name)
    return u unless u.nil?
    return Shop.find_by_name(name)
  end

  def self.default_quota
    20
  end

  def auto_register?
    name == phone
  end

  def quota
    #用户当前可以下载的优惠券的次数
    q=User.default_quota
    Consumption.recent_consumptions(self.id).each do |c|
      q+=5+c.money/100
    end
    Dcash.recent_dcash(self.id).each do |d|
      q += 5 + (d.line_item.price.to_f / d.line_item.quantity) * d.quantity / 100
    end
    q-=recent_sms_count
    # 下列手机号不限制每月免费下载量
    if ['13505810199', '13675862228', '15058124912', '18868792827', '13989841042','15990100662','15888870409'].index(self.phone)
      q = 1
    end
    q.to_i
  end

  def quota_str
    "你本月的短信下载限额已满!你每月免费可以从一渡网下载#{User.default_quota}条短信。每到商家实际消费一次短信优惠券，增加#{User.default_quota}条以上的短信下载许可。"
  end

  def recent_sms_count
    # 是否要将现金券计算在本月免费下载限额内?
    #
    SmsOut.count_by_sql("select count(*) from sms_outs where recipient='#{self.phone}' and create_date > '#{Time.now.last_month.strftime("%Y-%m-%d %H:%M:%S")}' ")
  end

  def delete_all_relevent_record
    self.consumptions.each { |e| e.destroy }
    self.ddowns.each { |e| e.destroy }
    self.destroy
  end

  def self.auth(name,password) #TODO 如何处理这个方法的重复，admin,shop,user都有同样的这个方法
    admin = self.find_by_name(name)
    if admin
      if admin.password != password
        admin = nil
      end
    end
    admin
  end

  def self.auth_shop_key(name, password, shop_key)
    admin = self.find_by_name_and_shop_key(name, shop_key)
    if admin
      if admin.password != password
        admin = nil
      end
    end
    admin
  end

  def self.auth_by_phone(phone,password) #TODO 如何处理这个方法的重复，admin,shop,user都有同样的这个方法
    phone = PhoneCompare.normalize(phone)
    admin = self.find(:first, :conditions => ["phone = ? or other_phones like ?", phone, "%#{phone}%"])
    if admin
      if admin.password != password
        admin = nil
      end
    end
    admin
  end

  def self.auth_by_qdh_phone(phone,password)
    phone = PhoneCompare.normalize(phone)
    admin = self.find(:first, :conditions => ["(phone = ? or other_phones like ?) and (shop_key = 'qiandaohu' or shop_key = 'qiandaohu_1dooo')", phone, "%#{phone}%"])
    if admin
      if admin.password != password
        admin = nil
      end
    end
    admin
  end

  def valid_upuserid
    errors.add(:upuserid, "找不到姓名/卡号是<#{@upuser_cardid}>的兼职客户经理")  if   !@upuser_cardid.blank? && upuserid.blank?
  end

  def upuser_cardid
    @upuser_cardid || ( "#{upuser_user.nickname}(#{upuser_user.cardid})" if upuser_user)
  end
  
  def upuser_cardid=(cardid_and_name)
    unless cardid_and_name.blank?
		  cardid = cardid_and_name.match(/\(\d*?\)$/)
		  user = self.class.find_by_cardid(cardid[0][1..-2])  if cardid
		  self.upuserid = user.id if user
		  @upuser_cardid = cardid_and_name
    else
    	self.upuserid = ''
    	self.upuser_scale = 0
    end
  end
  
  def qdh_delivers
    users = User.find_all_by_upuserid(id, :order => "created_at desc")
  end

  def phone2
    PhoneUtil.phone_hidden phone
  end

  def name_is_phone?
    return false if self.phone.nil?
    self.name.strip == self.phone.strip
  end

  def show_name
    sn = self.name.strip
    if self.phone && (self.name.strip == self.phone.strip)
      sn[3..6] = '****'
      # sn = sn.tr_s('/' + sn[-8..-5] + '/', '****')
    end
    sn
  end

  def have_phone?
    !phone.nil? && phone.length>1
  end

  #根据手机号码得到用户，或者自动创建用户
  #phone  手机号码
  #confirm 手机号码是否是真实的。如果是短信接口调用此函数，则其手机号码是真实的。如果是网站上用户自己输入的手机号码，则不是真实的。
  #shop_key 第三方网站带来的用户，分配给该网站的key
  #send_sms 自动注册的用户是否自动发通知短信
  def self.find_or_create_by_phone(phone,confirm=true, shop_key="", sendSmsFlag = false)
    phone = PhoneCompare.normalize(phone)
    u=User.find_by_phone_and_confirmed(phone,true)
    if u.nil?
      u=User.new
      u.phone=phone
      u.name=phone
      u.password=u.phone[1,6]
      #TODO: use random password
      u.confirmed = confirm
      u.shop_key = shop_key
      u.save!
      SmsOut.send_sms("恭喜您成为一渡网会员，你的登录密码为'#{u.password}'。你可以用本手机号码与登录密码登录一渡网http://www.1dooo.com，查询你的消费积分。",u.phone) if sendSmsFlag
    end
    u
  end

  def self.szh_find_or_create_by_phone(phone,confirm=true)
    u=User.find_by_phone phone
    if u.nil?
      u=User.new
      u.phone=phone
      u.name=phone
      u.password=u.phone[1,6]
      #TODO: use random password
      u.confirmed = confirm
      u.save!
    end

    u
  end

  def push_ksf?
    if push_time? && in_push_time(created_at)
      @pd = PushDiscount.find(:last)
      return @pd && (@pd.discount.remainder && (@pd.discount.remainder > 0)) && Ddown.find_by_discount_id_and_user_id(@pd.discount_id, self.id).nil?
    end
  end

  def radio996_order
    return nil
    @radio996 = Radio996.find_by_sql("select discount_id, discount_id2, start_time, end_time from radio996s where sec_now = 1 order by id desc limit 1")
    @orders = (@radio996.nil? || (@radio996.size == 0)) ? nil : Order.find_by_sql(["select orders.* from orders, line_items where line_items.order_id = orders.id and line_items.discount_id = ? and orders.user_id = ? and orders.flag = 0 )", @radio996[0].discount_id, self.id])
  end

  def self.merge_user(user_id, destroy_id)
    user = User.find(user_id)

    User.transaction do
      coin_flows = CoinFlow.find_all_by_user_id(destroy_id)
      coin_flows.each do |coin_flow|
        coin_flow.update_attributes({"user_id" => user.id}) if !coin_flow.nil?
      end

      comments = Base::Comment.find_all_by_user_id(destroy_id)
      comments.each do |comment|
        comment.update_attributes({"user_id" => user.id}) if !comment.nil?
      end
      consumptions = Consumption.find_all_by_user_id(destroy_id)
      consumptions.each do |consumption|
        consumption.update_attributes({"user_id" => user.id}) if !consumption.nil?
      end
      consumptions = Consumption.find_all_by_down_user_id(destroy_id)
      consumptions.each do |consumption|
        consumption.update_attributes({"down_user_id" => user.id}) if !consumption.nil?
      end

      dcashes = Dcash.find_all_by_user_id(destroy_id)
      dcashes.each do |dcash|
        dcash.update_attributes({"user_id" => user.id}) if !dcash.nil?
      end
      dcashes = Dcash.find_all_by_buyer_id(destroy_id)
      dcashes.each do |dcash|
        dcash.update_attributes({"buyer_id" => user.id}) if !dcash.nil?
      end

      dcash_xfs = DcashXf.find_all_by_user_id(destroy_id)
      dcash_xfs.each do |dcash_xf|
        dcash_xf.update_attributes({"user_id" => user.id}) if !dcash_xf.nil?
      end

      ddowns = Ddown.find_all_by_user_id(destroy_id)
      ddowns.each do |ddown|
        ddown.update_attributes({"user_id" => user.id}) if !ddown.nil?
      end

      favorites = Favorite.find_all_by_user_id(destroy_id)
      favorites.each do |favorite|
        favorite.update_attributes({"user_id" => user.id}) if !favorite.nil?
      end

      orders = Order.find_all_by_user_id(destroy_id)
      orders.each do |order|
        order.update_attributes({"user_id" => user.id}) if !order.nil?
      end


      user_findpasses = UserFindpass.find_all_by_user_id(destroy_id)
      user_findpasses.each do |user_findpass|
        user_findpass.update_attributes({"user_id" => user.id}) if !user_findpass.nil?
      end

      user_logos = UserLogo.find_all_by_user_id(destroy_id)
      user_logos.each do |user_logo|
        user_logo.update_attributes({"user_id" => user.id}) if !user_logo.nil?
      end

      destroy_user = User.find(destroy_id)
      user.score = user.score + destroy_user.score
      user.balance = user.balance + destroy_user.balance
      user.email = destroy_user.email if user.email.blank?
      user.sex = destroy_user.sex if user.sex.blank?
      user.occupation = destroy_user.occupation if user.occupation.blank?
      user.nickname = destroy_user.nickname if user.nickname.blank?
      user.oauth_t = destroy_user.oauth_t if user.oauth_t.blank?
      user.oauth_id = destroy_user.oauth_id if user.oauth_id.blank?
      user.oauth_name = destroy_user.oauth_name if user.oauth_name.blank?
      user.save
      destroy_user.delete
    end
  end

  def like_count
    UserShopLike.count(:conditions => ["user_id = ?", id])
  end

  def after_create
  end

  def isqiandaohu
    return Qdhbeer::QIANDAOHU_SHOP_KEY.include?(self.shop_key)
  end
  
  #时间段内的充值期初金额， 充值金额， 充值消费金额， 结余
  def user_recharge(start_day, end_day)
    origin_day = Time.parse("2011-07-01").to_date
    origin_end = start_day.to_date.ago(1).end_of_day
    
    recharge_start = self.period_recharge(origin_day ,origin_end) - self.period_recharge_cost(origin_day ,origin_end)
    recharge_amount = self.period_recharge(start_day,end_day.end_of_day)
    recharge_cost  = self.period_recharge_cost(start_day,end_day.end_of_day)
    recharge_end =   recharge_start + recharge_amount - recharge_cost
    [recharge_start, recharge_amount, recharge_cost, recharge_end  ]
  end
  
  #时间段内的赠酒期初金额， 充值金额， 充值消费金额， 结余
  def user_gift(start_day, end_day)
  	origin_day = Qdhbeer::REPORT_START_DAY
    origin_end = start_day.to_date.ago(1).end_of_day
    if self.user_type == 4
    	gift_start = self.period_gift_count(origin_day ,origin_end) - self.period_type1_count(origin_day ,origin_end)
    	gift_cost  = self.period_type1_count(start_day,end_day.end_of_day)
    else
    	gift_start = self.period_gift_count(origin_day ,origin_end) - self.period_gift_cost(origin_day ,origin_end)
    	gift_cost  = self.period_gift_cost(start_day,end_day.end_of_day)
    end
    gift_amount = self.period_gift_count(start_day,end_day.end_of_day)
    gift_end =   gift_start + gift_amount - gift_cost
    [gift_start, gift_amount, gift_cost, gift_end  ]
  end

  #时间段内的订单消费(含充值，赠送)
  def period_price(start_date, end_date)
    beerorders = Beerorder.find_by_sql(["select sum(count) * ? as sum_count from beerorders where flag != 4 and user_id = ? and served_at >= ? and served_at <= ?", Qdhbeer::QIANDAOHU_BEER_PRICE, id, start_date, end_date])
    beerorders.empty? ? 0.0 : beerorders[0].sum_count.to_f
  end

  #时间段内的赠酒消费
  def period_gift_price(start_date, end_date)
    beerorders = Beerorder.find_by_sql(["select sum(gift_count) * ? as sum_count from beerorders where flag != 4 and user_id = ? and served_at >= ? and served_at <= ?", Qdhbeer::QIANDAOHU_BEER_PRICE, id, start_date, end_date])
    beerorders.empty? ? 0.0 : beerorders[0].sum_count.to_f
  end

  
  #时间段内的充值消费
  def period_recharge_price(start_date, end_date)
    beerorders = Beerorder.find_by_sql(["select sum(count) * ? as sum_count, sum(gift_count) * ? as sum_gift_count from beerorders where user_id = ? and served_at >= ? and served_at <= ?", Qdhbeer::QIANDAOHU_BEER_PRICE, Qdhbeer::QIANDAOHU_BEER_PRICE, id, start_date.to_date, end_date.to_date.end_of_day])
    beerorders.empty? ? 0.0 : (beerorders[0].sum_count.to_f - beerorders[0].sum_gift_count.to_f)
  end

  #时间段内的充值
  def period_o_recharge(start_date, end_date)
    recharges = BeeruserRecharge.find_by_sql(["select sum(amount) as sum_amount from beeruser_recharges where user_id = ? and recharge_date between ? and ?", id, start_date, end_date])
    recharges.empty? ? 0.0 : recharges[0].sum_amount.to_f
  end
  
  #时间段内1dooo后台充值
  def period_dooo_recharge(start_date, end_date)
    BeeruserRecharge.sum(:amount,:conditions => ["user_id = ? and Date(recharge_date) between ? and ? and recharge_type = 1", self.id, start_date, end_date ])
  end

  #时间段内的千岛湖赠酒
  def period_gift(start_date, end_date)
    BeeruserGift.sum(:amount, :conditions => ["Date(gift_date) between ? and ? and user_id = ?", start_date, end_date, self.id] )
  end

  #时间段内的销售出库总额
  def period_good_out(start_date, end_date)
    good_outs = GoodOut.find(:all, :conditions => ["Date(out_datetime) between ? and ? and out_type =? and user_id = ?", start_date, end_date, 3, self.id ])
    good_outs.inject(0) { |m, n| m+ n.good.unitprice.to_f*n.amount }
  end

  #时间段内的转出转赠
  def period_present_cost(start_date, end_date,column)
    QdhBeerpresent.sum(column, :conditions => ["Date(created_at) between ? and ? and from_user_id = ?", start_date, end_date, self.id])*Qdhbeer::QIANDAOHU_BEER_PRICE
  end
  
  #时间段内的转入转赠
  def period_present_count(start_date, end_date, column = :amount)
    QdhBeerpresent.sum(column, :conditions => ["Date(created_at) between ? and ? and to_user_id = ?", start_date, end_date, self.id])*Qdhbeer::QIANDAOHU_BEER_PRICE
  end

  # 总充值消费 = 订单充值消费 + 销售出库 + 转赠中充值
  def period_recharge_cost(start_date, end_date)
    period_recharge_price(start_date, end_date) + period_good_out(start_date, end_date) + period_present_cost(start_date, end_date, :recharge_count) +0
  end

  # 总赠送消费 = 订单赠送消费 + 转赠的赠出
  def period_gift_cost(start_date, end_date)
    period_gift_price(start_date, end_date) + period_present_cost(start_date, end_date, :gift_count)
  end
  
  #总充值 = 充值 + 转赠的充值
	def period_recharge(start_date, end_date)
		period_o_recharge(start_date, end_date) + period_present_count(start_date, end_date, column = :recharge_count)
	end
   
 #总赠送 = 增酒 + 转赠的赠酒
  def period_gift_count(start_date, end_date)
    period_gift(start_date, end_date) + period_present_count(start_date, end_date, :gift_count)
  end

  #总客情用酒 = 客情用酒 + 转赠的赠出
  def period_type1_count(start_date, end_date)
    period_good_out_type1(start_date, end_date).to_f*Qdhbeer::QIANDAOHU_BEER_PRICE + period_present_cost(start_date, end_date, :gift_count)
  end

  #时间段内客情用酒
  def period_good_out_type1(start_date, end_date)
    good_outs = GoodOut.find_by_sql(["select sum(amount) as sum_amount from good_outs where good_id in (?) and recipient = ? and out_datetime >= ? and out_datetime <= ?", [5, 6, 7, 8], id, start_date, end_date])
    good_outs.empty? ? 0.0 : good_outs[0].sum_amount.to_f
  end

  def beer_recharges
    beeruser_recharges.inject(0) {|sum, b_r| sum = sum.to_f + b_r.amount.to_f }
  end

  def beer_gifts
    beeruser_gifts.inject(0) {|sum, b_g| sum = sum.to_f + b_g.amount.to_f }
  end

  def under_users_count(type =nil, start_at = nil, end_at = nil)
    start_at ||= Time.parse('2011-04-20')
    start_at, end_at = period_con(start_at, end_at)
    User.count(:all,:conditions => ["#{column(type)}=?  and created_at BETWEEN ? and ?", id, start_at, end_at])
  end

  def under_users(type = nil, end_at = nil, start_at = nil )
    start_at, end_at = period_con(start_at, end_at)
    User.find(:all, :conditions => ["#{column(type)} = ? and created_at BETWEEN ? and ?", id, start_at, end_at])
  end

  def serveuser_user
    User.find_by_id(serveuser_id)
  end

  def serveuser_users_count(start_at = nil, end_at = nil)
    serveuser_users(start_at, end_at).try(:length) || 0
  end



  def serveuser_users_recharges(start_at = nil, end_at = nil)
    if servetype.to_i > 0
      start_at, end_at = period_con(start_at, end_at)
      users = User.find(:all, :conditions => ["serveuser_id = ? and created_at BETWEEN ? and ?", id,  start_at, end_at])
      users.inject(0){|sum, user| sum = sum.to_f + user.period_recharge(start_at, end_at).to_f}
    else
      0
    end
  end



  def serveuser_users_orderprices(start_at = nil, end_at = nil)
    if servetype.to_i > 0
      start_at, end_at = period_con(start_at, end_at)
      users = User.find(:all, :conditions => ["serveuser_id = ? and created_at BETWEEN ? and ?", id,  start_at, end_at])
      users.inject(0){|sum, user| sum = sum.to_f + user.period_price(start_at, end_at).to_f}
    else
      0
    end
  end

  def serveuser_users(start_at = nil, end_at = nil)
    if servetype.to_i > 0
      start_at, end_at = period_con(start_at, end_at)
      User.find(:all, :conditions => ["serveuser_id = ? and created_at BETWEEN ? and ?", id, start_at, end_at])
    end
  end

  def serveuser_recharges( options={} )
    options.symbolize_keys!
    users = User.find(:all, :conditions => ["#{column(options[:type])} = ?", id])
    return [] if users.empty?
    user_ids = users.map { |u| u.id  }
    start_at, end_at = period_con(options[:start_at], options[:end_at])
    s, h = '', Hash.new
    s << "beeruser_recharges.user_id IN (:user_ids) and beeruser_recharges.recharge_date  BETWEEN :start_at and :end_at"
    h[:user_ids], h[:start_at], h[:end_at] = user_ids, start_at, end_at
    unless options[:cardid].blank?
      s << " and users.cardid like :cardid"
      h[:cardid] = "%#{options[:cardid]}%"
    end
    unless options[:nickname].blank?
      s << " and users.nickname like :nickname"
      h[:nickname] = "%#{options[:nickname]}%"
    end
    unless options[:phone].blank?
      s << " and users.phone like :phone"
      h[:phone] = "%#{options[:phone]}%"
    end
    unless options[:amount].blank?
      s << " and beeruser_recharges.amount = :amount"
      h[:amount] = options[:amount]
    end
    BeeruserRecharge.find(:all, :conditions => [s,h], :include => :user)
  end

  def serveuser_orderprices( options ={})
    options.symbolize_keys!
    users = User.find(:all, :conditions => ["#{column(options[:type])} = ?", id])
    return [] if users.empty?
    user_ids = users.map { |u| u.id  }
    start_at, end_at = period_con(options[:start_at], options[:end_at])
    s, h = '', Hash.new
    s << "beerorders.user_id IN (:user_ids) and beerorders.served_at  BETWEEN :start_at and :end_at and beerorders.count > 0"
    h[:user_ids], h[:start_at], h[:end_at] = user_ids, start_at, end_at
    unless options[:cardid].blank?
      s << " and users.cardid like :cardid"
      h[:cardid] = "%#{options[:cardid]}%"
    end
    unless options[:order_id].blank?
      s << " and beerorders.id like :order_id"
      h[:order_id] = "%#{options[:order_id]}%"
    end
    unless options[:nickname].blank?
      s << " and users.nickname like :nickname"
      h[:nickname] = "%#{options[:nickname]}%"
    end

    Beerorder.find(:all, :conditions => [s,h], :include => :user)
  end

  def self.find_user_by_phone_other_phones(phone)
    User.find(:all, :conditions => ["phone like ? or other_phones like ?", "%#{phone}%", "%#{phone}%"])
  end

  def upuser_user
    User.find_by_id(upuserid)
  end

  def confine_amount
    self.recharge_confine.to_i +  self.gift_confine.to_i
  end

  # 转赠优先转赠酒的。然后转充值。但限制的不能转
  def figure_present(pail)
    gift_cost, recharge_cost = 0, 0
    if pail <= to_pail(self.present_balance - gift_confine)
      gift_cost = pail
    elsif pail <= to_pail(self.present_balance - gift_confine  + self.recharge_balance - recharge_confine)
      gift_cost = to_pail(self.present_balance - gift_confine )
      recharge_cost = pail - gift_cost
    end
    [recharge_cost, gift_cost]
  end

  # 计算余额，优先扣除充值余额，不足再扣除赠送余额。超出总余额负充值余额
  def figure_balance(order)
    if self.recharge_balance >= order.orderprice
      self.recharge_balance -= order.orderprice
    else
      max_recharge_able = self.recharge_balance.to_i/Qdhbeer::QIANDAOHU_BEER_PRICE
      max_price = max_recharge_able*Qdhbeer::QIANDAOHU_BEER_PRICE
      stay_price = order.orderprice - max_price
      if stay_price > self.present_balance
        max_gift_able = (self.present_balance/Qdhbeer::QIANDAOHU_BEER_PRICE).to_i
        order.gift_count = max_gift_able
        self.recharge_balance -= (order.orderprice - max_gift_able*Qdhbeer::QIANDAOHU_BEER_PRICE)
        self.present_balance -= max_gift_able*Qdhbeer::QIANDAOHU_BEER_PRICE
      else
        self.recharge_balance -=  max_price
        order.gift_count = (stay_price/Qdhbeer::QIANDAOHU_BEER_PRICE).to_i
        self.present_balance = self.present_balance - stay_price
      end
    end
  end

  def refigure_balance(beerorder, gift_count,count)
    self.cancle_balance(beerorder.gift_count.to_i, count * Qdhbeer::QIANDAOHU_BEER_PRICE)
    beerorder.gift_count = gift_count
    self.present_balance -=  beerorder.gift_count* Qdhbeer::QIANDAOHU_BEER_PRICE
    self.recharge_balance -= (beerorder.count - beerorder.gift_count)* Qdhbeer::QIANDAOHU_BEER_PRICE
  end

  def cancle_balance(gift_count, price)
    if gift_count > 0
      self.present_balance += gift_count*Qdhbeer::QIANDAOHU_BEER_PRICE
      self.recharge_balance += (price - gift_count*Qdhbeer::QIANDAOHU_BEER_PRICE)
    else
      self.recharge_balance += price
    end
  end

  def recharges_amount(start_at = nil, end_at = nil, options ={})
    start_at, end_at = period_con(start_at, end_at)
    recharges = self.period_recharges(start_at , end_at,options )
    recharges.sum(&:amount)
  end
  def order_amount(start_at = nil, end_at = nil, options = {})
    start_at, end_at = period_con(start_at, end_at)
    users = User.find(:all, :conditions => ["#{column(options['type'])} = ?", id])
    users.inject(0){|sum, user| sum = sum.to_f + user.period_price(start_at, end_at).to_f}
  end

  def upuser_amount(start_at = nil, end_at = nil)
    start_at, end_at = period_con(start_at, end_at)
    users = User.find(:all,:conditions => ["upuserid = ?", id])
    users.inject(0){|sum, user| sum += user.period_price(start_at, end_at).to_f * user.upuser_scale }
  end
  
  def period_recharges(start_at = nil, end_at = nil, options ={})
    start_at, end_at = period_con(start_at, end_at)
    users = User.find(:all, :conditions => ["#{column(options['type'])} = ?", id])
    BeeruserRecharge.find_by_sql(["select * from beeruser_recharges where user_id in (?) and recharge_date >= ? and recharge_date <= ?", users.map{|m| m.id}, start_at, end_at])
  end

  def user_type
    return 4 if is_staff?
    Userreport::USERTYPE[self.kind]
  end

  def user_shop_key_name
    {"qiandaohu" => "千岛湖啤酒", "qiandaohu_1dooo" => '一渡网'}[self.shop_key]
  end

  private
  def is_staff?
    self.shop_id == 712 && self.shop_key == 'qiandaohu'
  end

  def column(type = nil)
    type == "upuser" ? "upuserid" : "serveuser_id"
  end

  def period_con(start_at = nil, end_at = nil)
    start_at = start_at.blank? ? Qdhbeer::REPORT_START_DAY : start_at
    end_at = end_at.blank? ? Time.now : end_at.end_of_day
    [start_at, end_at]
  end


  def push_time?
=begin
    @start_time1 = Time.zone.parse("2010-04-28 08:00:00")
    @end_time1 = Time.zone.parse("2010-04-28 18:00:00")
    @start_time2 = Time.zone.parse("2010-04-29 08:00:00")
    @end_time2 = Time.zone.parse("2010-04-29 18:00:00")
    if (@start_time1 <= Time.zone.now && Time.zone.now <=  @end_time1) || (@start_time2 <= Time.zone.now && Time.zone.now <=  @end_time2)
      return true
    else
      return false
    end
=end
    @start_time1 = Time.zone.parse("2010-05-12 08:00:00")
    @end_time1 = Time.zone.parse("2010-05-12 18:00:00")
    if (@start_time1 <= Time.zone.now && Time.zone.now <=  @end_time1)
      return true
    else
      return false
    end
  end

  def in_push_time(n_time)
    if n_time
=begin
      @start_time1 = Time.zone.parse("2010-04-28 08:00:00")
      @end_time1 = Time.zone.parse("2010-04-28 18:00:00")
      @start_time2 = Time.zone.parse("2010-04-29 08:00:00")
      @end_time2 = Time.zone.parse("2010-04-29 18:00:00")
      if (@start_time1 <= n_time && n_time <=  @end_time1) || (@start_time2 <= n_time && n_time <=  @end_time2)
        return true
      else
        return false
      end    
=end
      @start_time1 = Time.zone.parse("2010-05-12 08:00:00")
      @end_time1 = Time.zone.parse("2010-05-12 18:00:00")
      if (@start_time1 <= n_time && n_time <=  @end_time1)
        return true
      else
        return false
      end
    end
  end

  def to_pail(amount)
    amount/Qdhbeer::QIANDAOHU_BEER_PRICE
  end


end
