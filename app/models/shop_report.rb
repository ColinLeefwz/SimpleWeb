class ShopReport
  include Mongoid::Document

  field :sid, type: Integer
  field :uid, type: Moped::BSON::ObjectId
  field :des
  field :flag,type: Integer
  field :type  #报错类型


  with_options :prefix => true, :allow_nil => true do |option|
    option.delegate :name, :to => :user
    option.delegate :name, :id, :addr, :lo, :to => :shop
  end


  def shop
    Shop.find_by_id(self.sid)
  end

  def user
     User.find_by_id(self.uid)
  end

  def report_flag
    case self.flag
    when nil
      @flag = "未处理"
    when 1
      @flag = "已处理"
    when 2
      @flag = "忽略"
    end
    @flag
  end

  def recommend_operation
    case self.type
    when "地点位置错误"
      @operation = "修改地点位置"
      @url = "/admin_user_reports/modify_location?id=#{self.id}"
    when "地点信息错误"
      @operation = "修改地点信息"
      @url = "/admin_user_reports/modify_infor?id=#{self.id}"
    when "地点不存在"
      @operation = "删除地点"
      @url = "/admin_user_report/repot_del?id=#{self.id}"
    when "地点重复"
      @operation = "获取重复商家"
      @url = "/admin_user_reports/repeat?id=#{self.id}"
    end
    hash = {operation: @operation, url: @url}
  end
end
