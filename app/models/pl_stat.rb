class PlStat
  include Mongoid::Document
  field :date, type:String
  field :pl_people_num, type:Array
  field :pl_reply_num, type:Array
  field :pl_words_num, type:Array

  #计算一天内陪聊人员与多少人聊过
  def chat_people_num
    pl_people = ["51418836c90d8bc37b000567","513ed1e7c90d8b590100016f","50bec2c1c90d8bd12f000086",
               "51427b92c90d8b670c00027b","514190f8c90d8bc67b00054a"]
    num = []
    (0..pl_people.length-1).each do |x|
      utnl = User.find_by_id(pl_people[x]).user_talk_new.length
      num.push(utnl)
    end
    return num
  end

  #计算在一天内陪聊用户聊天话的数量
  def chat_words_num
    pl_people = ["51418836c90d8bc37b000567","513ed1e7c90d8b590100016f","50bec2c1c90d8bd12f000086",
               "51427b92c90d8b670c00027b","514190f8c90d8bc67b00054a"]
    num = User.find_by_id(pl_people[n]).user_talk_new.length
    num = []
    sum = 0
    (0..pl_people.length-1).each do |y|
      utnl = User.find_by_id(pl_people[y]).user_talk_new.length
      (0..utnl-1).each do |x|
        sum2 = @pl1.human_chat(User.find_by_id(@pl1.chat[x][0]).id).length
        sum += sum2
      end
    end
    num
  end

  #计算当前pl_stat, 并保存到mongo中
  def do_count(data)
  	user_talk_new(date)
    self.data = data
    self.pl_people_num = chat_people_num
    self.pl_reply_num = chat_people_num
    self.pl_words_num = chat_words_num
    self.save
  end

  #从缓存中获取当日陪聊信息
  def self.user_talk_new(date)
    content = $redis.smembers("PL#{date}#{self.id}")
    return content
  end

  #类方法，cron的调用接口，每天执行一次
  def self.do_count(date = nil)
    if date.nil?
      date = Time.now.strftime("%Y-%m-%d")
  	end
    ua = self.new
    ua.do_count(date)
  end
  
end