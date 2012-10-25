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
    User.find($1)
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