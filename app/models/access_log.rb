class AccessLog < ActiveRecord::Base

  def self.table_name
    get_or_gen_table_name
  end

  def self.get_or_gen_table_name(prefix="access")
    ret = AccessLog.get_table_name(Time.now,prefix)
    unless connection.table_exists?(ret)
      connection.execute("create table #{ret} select * from #{prefix}_logs where 1<>1")
    end
    return ret
  end

  def self.get_table_name(tm,prefix="access")
    if !tm.nil? && tm.year>2010
      return "#{prefix}_#{tm.strftime('%Y%m')}logs"
    else
      return "#{prefix}_logs"
    end
  end

  def parse_unknown_agent
    return unless self.agent
    agent_downcase = self.agent.downcase
    return self.agent_name = "Firefox" if agent_downcase.index("firefox")
    %w[google baidu sogou soso youdao bing yahoo dotbot jakarta wasitup yandex curl wget alexa java].each do |x| 
      if agent_downcase.index(x)
        self.agent_os = x 
        self.agent_name = "spider"
        return
      end
    end
    unless self.agent_name
      %w[spider bot crawler].each do |x| 
        return self.agent_name = "spider" if agent_downcase.index(x)
      end
    end
    if agent_downcase.index("ucweb")
      self.agent_os = "mobile"
      self.agent_name = "ucweb"
      return
    end
    if agent_downcase.index("iphone")
      self.agent_os = "mobile"
      self.agent_name = "iphone"
    end
  end


end
