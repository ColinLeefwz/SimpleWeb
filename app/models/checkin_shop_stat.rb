class CheckinShopStat
  include Mongoid::Document
  field :_id, type: Integer
  field :users, type:Hash # 用户id => [总次数、最后一次签到的id、性别]
  field :ips, type:Hash # ip地址 => [总次数、最后一次签到的id]
  field :utotal, type: Integer #用户总数
  field :uftotal, type: Integer #女性用户总数
  field :ctotal, type: Integer #签到总次数

  def shop
    Shop.find_by_id(self.id)
  end

  def user(user_object_id)
    user_object_id =~ /"(.*?)"/
    User.find_by_id($1)
  end

  def self.add_one_redis(shop_id,gender)
    $redis.incr("suac#{shop_id.to_i}")
    $redis.incr("sufc#{shop_id.to_i}") if gender==2
  end

  def self.get_user_count_redis(shop_id)
    all = $redis.get("suac#{shop_id.to_i}")
    female = $redis.get("sufc#{shop_id.to_i}")
    all=0 if all.nil?
    female=0 if female.nil?
    [all.to_i,female.to_i]
  end

  def set_user_count_redis
    $redis.set("suac#{self._id.to_i}",utotal.to_i) #suac mean shop-users-all-count
    $redis.set("sufc#{self._id.to_i}",uftotal.to_i)  #sufc mean shop-users-female-count 
  end
  
  def self.del_user_count_redis(id)
    $redis.del("suac#{id.to_i}") 
    $redis.del("sufc#{id.to_i}")
  end
  
  def self.del_with_redis(id)
    CheckinShopStat.del_user_count_redis(id)
    css = CheckinShopStat.find_by_id(id)
    return if css.nil?
    css.destroy
  end

  def self.init_user_count
    CheckinShopStat.all.each do |x|
      x.set_user_count_redis
      x.set_my_cache #商家用户签到统计始终保存在cache中
    end
  end

end

=begin
{
  "_id" : 4959531,
  "ctotal" : 5,
  "ips" : {
    "183/137/165/135" : [
      3,
      ObjectId("5066d1fb421aa9fd1700000d")
    ],
    "122/229/28/44" : [
      2,
      ObjectId("5066e377421aa9cf20000002")
    ]
  },
  "uftotal" : 0,
  "users" : {
    "ObjectId("50446058421aa92042000002")" : [
      4,
      ObjectId("5066e31d421aa94821000003"),
      1
    ],
    "ObjectId("5032e88d421aa91a1e000016")" : [
      1,
      ObjectId("5066e377421aa9cf20000002"),
      1
    ]
  },
  "utotal" : 2
}
=end