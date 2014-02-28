class Lottery
  include Mongoid::Document

  field :sid, type: Integer
  field :gid, type: Integer
  field :name #活动名称
  field :info #兑奖信息
  field :stime #活动开始时间
  field :etime #活动结束时间
  field :des #活动说明
  field :end_title #活动结束标题
  field :end_des #活动结束说明

  field :gl,type:Integer #中奖概率
  field :cnum #每天抽奖次数

  field :type1 #奖品类别
  field :jname1 #奖品名称
  field :jnum1 #奖品数量

  field :type2
  field :jname2
  field :jnum2

  field :type3
  field :jname3
  field :jnum3

  field :type4
  field :jname4
  field :jnum4

  field :type5
  field :jname5
  field :jnum5

  field :type6
  field :jname6
  field :jnum6

  # has_many :lottery_prizes, :dependent => :destroy

  scope :ggk, -> { where(:gid => 1) }

  scope :dzp, -> { where(:gid => 2) }

  validates_presence_of :name, :info, :stime, :etime, :des

  def show_guaguaka_reword
    hash = { "一等奖" => gl/300.0000, "二等奖" => gl/300.0000, "三等奖" => gl/300.0000, "谢谢惠顾" => (1-gl/100.0000) }
    hash.to_a.map { |el| Array.new(el[1]*100, el[0]) }.flatten.sample
  end

  def redis_key
    "Lottery#{self.gid}-#{self.sid}"
  end
  
  def add_redis
    $redis.zadd(redis_key,score,self.uid)
  end

end