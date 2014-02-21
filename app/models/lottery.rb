class Lottery
  include Mongoid::Document

  field :sid, type: Integer
  field :name #活动名称
  field :info #兑奖信息
  field :time #活动时间
  field :des #活动说明
  field :end_title #活动结束标题
  field :end_des #活动结束说明
  field :type #奖品类别
  field :jname #奖品名称
  field :jnum, type: Integer #奖品数量
  field :gl #中奖概率
  field :cnum #每天抽奖次数

  validates :name, :presence => true
  validates :info, :presence => true
  validates :time, :presence => true
  validates :des, :presence => true

  def show_guaguaka_reword
    hash = { "一等奖" => gl/3, "二等奖" => gl/3, "三等奖" => gl/3, "谢谢惠顾" => (1-gl) }
    hash.to_a.map { |el| Array.new(el[1]*100, el[0]) }.flatten.sample
  end

end